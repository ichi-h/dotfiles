---
name: task-management
description: sqlツールを用いたタスク管理スキル。解決すべき課題の計画・その計画に紐づくタスク・タスクの実行順序を決定する依存関係の管理、次に実行すべきタスクの取得、タスクの状態管理の方法を提供する。計画を前提とした開発を行う際に有効である。一方で、計画の設計が不十分または困難である場合、タスクの分解が不要なほどシンプルな課題の解決を行う場合には適切ではない。
---

# Task Management スキル

`sql` ツールを用いたタスク管理を提供するスキル。

## テーブル定義

```sql
PRAGMA foreign_keys = ON;

CREATE TABLE plans (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uid TEXT UNIQUE NOT NULL CHECK(length(uid) = 4), -- ランダムな4文字の英数字
  title TEXT NOT NULL, -- 課題の概要
  description TEXT NOT NULL, -- 課題解決の計画の詳細
  state TEXT CHECK(state IN ('not_yet', 'in_progress', 'completed')) NOT NULL, -- not_yet（未着手）, in_progress（進行中）, completed（完了）
);

CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uid TEXT UNIQUE NOT NULL CHECK(length(uid) = 4), -- ランダムな4文字の英数字
  plan_id INTEGER NOT NULL, -- タスクが属する計画のID
  title TEXT NOT NULL, -- タスクの概要
  description TEXT NOT NULL, -- タスクの具体的な内容やチェックリストなど
  state TEXT CHECK(state IN ('not_yet', 'completed', 'canceled')) NOT NULL, -- not_yet（未着手）, completed（完了）, canceled（中止）
  FOREIGN KEY (plan_id) REFERENCES plans(id)
);

CREATE TABLE task_dependencies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id INTEGER NOT NULL,
  depends_on_task_id INTEGER NOT NULL, -- task_idが依存しているタスクのID
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (depends_on_task_id) REFERENCES tasks(id)
);
```

### 補足

- tasks.stateがcanceledとなっているタスクは、解決不要と判断されたタスクであり実行は行われていないが、タスクの依存関係上は完了と同等に扱う。
- タスクの実行順は依存関係によって管理される。
  - あるタスクを実行するためには、そのタスクが依存しているすべてのタスクがcompletedまたはcanceledである必要がある。
  - どのタスクにも依存していないタスクは、最初から実行可能なタスクとみなされる。
- タスクの実行順序が変更されることは基本的に考慮しない。

## タスク管理の基本フロー

### 1. 与えられた計画を分析し、plans, tasks, task_dependenciesテーブルへと落とし込む

- plans.stateは、すぐに課題解決に取り組む場合はin_progress、そうでない場合はnot_yetとする。

### 2. 取り組むべき並列実行可能なタスクをすべて取得し、遂行する

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

### 3. タスク完了後に、そのタスクの状態をcompletedに更新する

```sql
UPDATE tasks
SET state = 'completed'
WHERE uid IN ('fe3a', 'w2gi', ...); -- 完了したタスクのuidを指定
```

### 3. 2番と3番を計画が完了するまで繰り返す

2番によって得られるタスクがなくなった場合、すべてのタスクが完了したとみなされる。

## クエリの作成について

計画やタスク内容の変更、stateの更新などの細かい操作は、上記のルールやフローに従って随時クエリを作成することが許される。  
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
