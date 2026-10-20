---
name: task-management
description: sqllite3を用いたタスク管理スキル。解決すべき課題（チケット）・その課題をに紐づくタスク・タスクの実行順序を決定する依存関係の管理、次に実行すべきタスクの取得、タスクの状態管理の方法を提供する。解決すべき課題が明確な開発のタスク管理を行う際に有効である。一方で、タスクの分解が不要なほどシンプルな課題の解決を行う場合には適切ではない。
---

# Task Management スキル

`sqllite3` コマンドを用いたタスク管理方法を提供するスキル。

## 用語定義

- **課題**
  - 解決すべき問題。
  - 課題は1つの関心しか取り扱ってはならず、それぞれの課題は独立したものとして取り扱わなければならない。
  - 課題は「何が問題となっているのか」「なぜ解決しなければならないのか」「解決の大まかな方針」の3つ（以下、課題三要素と呼ぶ）が含まれていなければならない。
- **チケット**
  - 解決すべき課題の単位。
  - 各チケットは独立しており、1つのチケットは1つの課題しか取り扱ってはならない。
- **タスク**
  - 課題を解決するために必要な工程を指す。
  - タスクは1つの課題に対して複数紐づく。
  - すべてのタスクが完了した場合、その課題は解決されていなければならない。
  - タスクはなるべく小さく分割されていなければならない。

## テーブル定義

```sql
PRAGMA foreign_keys = ON;

-- チケットを管理するテーブル
CREATE TABLE tickets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uid TEXT UNIQUE NOT NULL CHECK(length(uid) = 4), -- ランダムな4文字の英数字
  title TEXT NOT NULL, -- 課題の概要
  description TEXT NOT NULL, -- 課題の詳細（課題三要素）
  state TEXT CHECK(state IN ('not_yet', 'in_progress', 'completed', 'archived')) NOT NULL, -- not_yet（未着手）, in_progress（進行中）, completed（完了）, archived（アーカイブ）
);

-- チケットに紐づくタスクを管理するテーブル
-- tasks.stateがcanceledとなっているタスクは、解決不要と判断されたものであり、実行は行われていないが、タスクの依存関係上は完了と同等に扱う。
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uid TEXT UNIQUE NOT NULL CHECK(length(uid) = 4), -- ランダムな4文字の英数字
  ticket_id INTEGER NOT NULL, -- タスクが属するチケットのID
  title TEXT NOT NULL, -- タスクの概要
  description TEXT NOT NULL, -- タスクの具体的な内容やチェックリストなど
  state TEXT CHECK(state IN ('not_yet', 'completed', 'canceled')) NOT NULL, -- not_yet（未着手）, completed（完了）, canceled（中止）
  FOREIGN KEY (ticket_id) REFERENCES tickets(id)
);

-- タスク間の依存関係を管理するテーブル
-- - タスクの実行順は依存関係によって管理される。
--   - あるタスクを実行するためには、そのタスクが依存しているすべてのタスクがcompletedまたはcanceledである必要がある。
--   - どのタスクにも依存していないタスクは、最初から実行可能なタスクとみなされる。
-- - タスクの実行順序が変更されることは基本的に考慮しない。
CREATE TABLE task_dependencies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id INTEGER NOT NULL,
  depends_on_task_id INTEGER NOT NULL, -- task_idが依存しているタスクのID
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (depends_on_task_id) REFERENCES tasks(id)
);
```

## タスク管理の基本フロー

### 0. （データベースファイルが存在しない場合）各課題を管理するデータベースファイルを作成する

- 作成場所: `$(pwd)/.ichi-h/issues.db`
- データベース作成時にtickets, tasks, task_dependenciesテーブルを作成する。

### 1. 与えられた課題を分析し、ticketsへと保存する

- 与えられた課題が複数の関心を抱えている場合は、その関心事にチケットを分割すること。
- 課題三要素が明確にすることができない場合は、その理由を提示してユーザーへ検討を促すこと。

### 2. 与えられた課題から、解決へと至るために必要な全工程を分析し、tasks, task_dependenciesテーブルへと落とし込む

- tickets.stateは、すぐに課題解決に取り組む場合はin_progress、そうでない場合はnot_yetとする。

### 3. 取り組むべき並列実行可能なタスクをすべて取得し、遂行する

```sql
SELECT t.*
FROM tasks t
WHERE t.state = 'not_yet'
  AND NOT EXISTS (
    SELECT 1
    FROM task_dependencies td
    JOIN tasks t2 ON td.depends_on_task_id = t2.id
    WHERE td.task_id = t.id
      AND t2.state NOT IN ('completed', 'canceled')
  )
```

### 4. タスク完了後に、そのタスクの状態をcompletedに更新する

```sql
UPDATE tasks
SET state = 'completed'
WHERE uid IN ('fe3a', 'w2gi', ...); -- 完了したタスクのuidを指定
```

### 5. 3番と4番をチケットに紐づく全タスクが完了するまで繰り返す

3番によって得られるタスクがなくなった場合、すべてのタスクが完了したとみなす。

## クエリの作成について

チケットやタスクの変更、stateの更新などの細かい操作は、上記のルールやフローに従って随時クエリを作成することが許される。  
ただし、以下のパターンについてはそれぞれの内容に従って実行すること。

### タスクの差し込み

あるタスクの次に別のタスクの差し込みが発生した場合、以下のクエリを実行する。

```sql
-- 例: タスクID 4の次に新しいタスクを差し込む場合

-- 新しいタスクを追加
INSERT INTO tasks (title, uid, description, state)
VALUES ('新しいタスク', 'e3at', 'タスクの詳細', 'not_yet'); -- uidはランダムな4文字の英数字を指定

-- タスクID 4の次に新しいタスクが来るよう依存関係を追加
INSERT INTO task_dependencies (task_id, depends_on_task_id)
VALUES ((SELECT id FROM tasks WHERE uid = 'e3at'), 4);

-- タスクID 4に依存しているタスクに、新しいタスクも依存させる
INSERT INTO task_dependencies (task_id, depends_on_task_id)
SELECT task_id, (SELECT id FROM tasks WHERE uid = 'e3at') FROM task_dependencies
WHERE depends_on_task_id = 4;
```
