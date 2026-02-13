---
name: backlog-management
description: バックログ解決のためのバックログ管理方法を定義します。バックログファイルの構造、フォーマット、命名規則、依存関係、品質保証タスクのガイドラインを提供します。
---

# バックログ管理スキル

## バックログステータス

バックログには以下のステータスを設定します:

| ステータス | 説明 | 状態 |
|---|---|---|
| `planning` | 計画中 | バックログの追加のみを行った状態 |
| `planned` | 計画済み | task-managerのタスク定義が完了した状態 |
| `in-progress` | 進行中 | バックログの解決が進行している状態 |
| `completed` | 完了 | バックログの解決が完了した状態 |
| `paused` | 一時停止 | 何らかの理由でバックログの解決が一時停止している状態 |
| `archived` | アーカイブ | バックログの解決が不要になった状態（例: 誤って追加された、既に解決されているなど） |

## バックログファイルの構造

### ファイルの場所

バックログファイルは以下の形式で保存されます：

```
.{username}/{year}-{month}-{day}-{backlog-name}.md
```

**例**:

- `.ichi-h/2026-02-12-user-authentication.md`
- `.ichi-h/2026-03-15-fix-memory-leak.md`

**命名規則**:

- `{username}`: ユーザー名（例: ichi-h）
- `{year}-{month}-{day}`: バックログ作成日（YYYY-MM-DD形式）
- `{backlog-name}`: バックログ名（kebab-case）

### ファイルフォーマット

```markdown
# {backlog-name}

status: planning

## 概要

このバックログが達成しようとしていることの説明

## タスク

- [ ] タスクの説明 (task-{id})
- [ ] タスクの説明 (task-{id})
  - dependent on: {task-id1}
- [ ] タスクの説明 (task-{id})
  - dependent on: {task-id1}
- [ ] タスクの説明 (task-{id})
  - dependent on: {task-id1}
- [ ] タスクの説明 (task-{id})
  - dependent on: {task-id1}, {task-id2}
```

## タスクID

### フォーマット

- 形式: `task-{random-4-char}`
- 小文字の英字と数字のみ使用
- 同じバックログ内で一意である必要がある
- **例**: `task-a7f3`, `task-x9k2`, `task-m4p1`, `task-b2c8`

### 生成方法

ランダムな4文字の文字列を生成します。英数字（小文字）のみ。

## タスクの説明

### フォーマット

```markdown
- [ ] タスクの説明 (task-{id})
```

### 例

```markdown
- [ ] 認証システムのアーキテクチャを設計する (task-a1b2)
- [ ] JWTトークンの生成と検証を実装する (task-c3d4)
- [ ] 認証エンドポイントのユニットテストを追加する (task-e5f6)
```


### ベストプラクティス

- **動作動詞を使用**: 実装、設計、修正、追加、レビュー、テスト
- **具体的に**: 何をするかを明確に
- **必要に応じてコンテキストを含める**
- **簡潔かつ明確に**

## 依存関係の指定

### フォーマット

```markdown
- [ ] タスクの説明 (task-{id})
  - dependent on:
    - {task-id1}
    - {task-id2}
    - ...
```

### ルール

- 直接的な依存関係のみをリストする
- 依存関係のないタスクには注釈なし
- 依存関係は同じファイル内に存在するタスクIDである必要がある
- すべての依存タスクが完了するまで実行できない

### 並列実行

依存関係のないタスク、または依存関係がすべて完了したタスクは並列実行できます。

**例**:

```markdown
- [x] システム設計 (task-a1b2)
- [ ] フロントエンド実装 (task-c3d4)
  - dependent on: task-a1b2
- [ ] バックエンド実装 (task-e5f6)
  - dependent on: task-a1b2
- [ ] 統合テスト (task-g7h8)
  - dependent on: task-c3d4, task-e5f6
```

実行順序:

1. `task-a1b2` を実行
2. `task-a1b2` 完了後、`task-c3d4` と `task-e5f6` を**並列実行**
3. 両方完了後、`task-g7h8` を実行

## タスクの粒度

### 適切な粒度

- **1タスク = 15分〜2時間の作業**
- 各タスクは1つのエージェントで完了可能
- 明確な入力と出力がある
- 独立して検証可能

### 避けるべきこと

- **大きすぎるタスク** (> 2時間): より小さい単位に分割
- **小さすぎるタスク** (< 15分): 関連するマイクロタスクをまとめる
- **曖昧なタスク**: 具体的な行動が不明確

## 品質保証タスク

### 必須のQAタスク

すべての実装には以下を含める必要があります:

1. **コードレビュー**: 実装後
2. **セキュリティレビュー**: セキュリティに関わる機能の場合は必須
3. **テスト**: ユニットテスト、統合テストなど

### QAタスクの配置

- 実装タスクの後に配置
- 適切な依存関係を設定
- 並列実行可能な場合は並列に（例: コードレビューとセキュリティレビュー）

**例**:

```markdown
- [x] 認証機能を実装 (task-a1b2)
- [x] テストを追加 (task-c3d4)
  - dependent on: task-a1b2
- [ ] コードレビュー (task-e5f6)
  - dependent on: task-c3d4
- [ ] セキュリティレビュー (task-g7h8)
  - dependent on: task-c3d4
```

`task-e5f6` と `task-g7h8` は並列実行可能。

## バックログファイルの操作

### 新規作成

1. 適切な命名規則でファイルパスを決定
2. `create` ツールを使用してファイルを作成
3. 上記のフォーマットに従ってコンテンツを記述

### 既存ファイルの更新

1. `view` ツールで現在の内容を読み込む
2. **完了済みタスク (`[x]`) は保持する**
3. 新しいタスクを追加（新しいタスクIDで）
4. 必要に応じて依存関係を更新
5. `edit` ツールでファイルを更新

### タスクの完了マーク

タスクが正常に完了したら:

```markdown
変更前: - [ ] タスクの説明 (task-{id})
変更後: - [x] タスクの説明 (task-{id})
```

`edit` ツールを使用して `- [ ]` を `- [x]` に変更します。

## バックログファイルの例

### 例1: 機能実装

```markdown
# user-authentication-system

status: planned

## 概要

サインアップ、ログイン、パスワードハッシュ化、セッション管理を含む、安全なJWTベースの認証システムを実装します。

## タスク

- [ ] JWT認証のアーキテクチャとデータモデルを設計 (task-a1b2)
- [ ] 認証設計のセキュリティレビュー (task-c3d4)
  - dependent on: task-a1b2
- [ ] ユーザーモデルとデータベースマイグレーションを実装 (task-e5f6)
  - dependent on: task-c3d4
- [ ] JWT生成と検証ユーティリティを実装 (task-g7h8)
  - dependent on: task-c3d4
- [ ] ログインAPIエンドポイントを実装 (task-i9j0)
  - dependent on: task-g7h8
- [ ] サインアップAPIエンドポイントを実装 (task-k1l2)
  - dependent on: task-e5f6
- [ ] 保護されたルート用の認証ミドルウェアを追加 (task-m3n4)
  - dependent on: task-g7h8
- [ ] 認証フロー用のユニットテストと統合テストを追加 (task-o5p6)
  - dependent on: task-i9j0, task-k1l2, task-m3n4
- [ ] 認証実装のコードレビュー (task-q7r8)
  - dependent on: task-o5p6
- [ ] 認証実装のセキュリティレビュー (task-s9t0)
  - dependent on: task-o5p6
```

### 例2: バグ修正

```markdown
# fix-memory-leak-data-processing

status: planned

## 概要

データ処理モジュールのメモリリークを調査・修正し、将来のリークを防ぐためのモニタリングを追加します。

## タスク

- [ ] データ処理モジュールのメモリリーク原因を調査 (task-a1b2)
- [ ] 特定されたメモリリークを修正 (task-c3d4)
  - dependent on: task-a1b2
- [ ] メモリ使用量のモニタリングとアラートを追加 (task-e5f6)
  - dependent on: task-c3d4
- [ ] メモリが適切に解放されることを検証する回帰テストを追加 (task-g7h8)
  - dependent on: task-c3d4
- [ ] メモリリーク修正のコードレビュー (task-i9j0)
  - dependent on: task-e5f6, task-g7h8
```

### 例3: 更新されたバックログファイル（セキュリティ問題発見後）

```markdown
# user-authentication-system

status: in-progress

## 概要

サインアップ、ログイン、パスワードハッシュ化、セッション管理を含む、安全なJWTベースの認証システムを実装します。

## タスク

- [x] JWT認証のアーキテクチャとデータモデルを設計 (task-a1b2)
- [x] 認証設計のセキュリティレビュー (task-c3d4)
  - dependent on: task-a1b2
- [x] ユーザーモデルとデータベースマイグレーションを実装 (task-e5f6)
  - dependent on: task-c3d4
- [x] JWT生成と検証ユーティリティを実装 (task-g7h8)
  - dependent on: task-c3d4
- [x] ログインAPIエンドポイントを実装 (task-i9j0)
  - dependent on: task-g7h8
- [x] サインアップAPIエンドポイントを実装 (task-k1l2)
  - dependent on: task-e5f6
- [x] 保護されたルート用の認証ミドルウェアを追加 (task-m3n4)
  - dependent on: task-g7h8
- [x] 認証フロー用のユニットテストと統合テストを追加 (task-o5p6)
  - dependent on: task-i9j0, task-k1l2, task-m3n4
- [x] 認証実装のコードレビュー (task-q7r8)
  - dependent on: task-o5p6
- [x] 認証実装のセキュリティレビュー（脆弱性発見） (task-s9t0)
  - dependent on: task-o5p6
- [ ] パスワードハッシュのソルト生成の脆弱性を修正 (task-u1v2)
  - dependent on: task-s9t0
- [ ] 適切なソルト生成を検証するテストを更新 (task-w3x4)
  - dependent on: task-u1v2
- [ ] セキュリティレビューを再実行 (task-y5z6)
  - dependent on: task-w3x4
```

**注意**:

- 完了したタスクは `[x]` で保持
- 新しいタスクには新しいIDを使用
- 依存関係を適切に更新

## 重要な注意事項

1. **バックログファイルが真実の源**: 常にバックログファイルを読んで更新する
2. **完了タスクは保持**: 更新時に `[x]` マーカーを保持
3. **一意のタスクID**: 同じバックログ内で重複しないようにする
4. **依存関係を最小化**: 不必要な順次実行を避け、並列性を最大化
5. **品質計画**: 常にレビューとテストのタスクを含める
6. **セキュリティ優先**: セキュリティに関わる機能には必須のセキュリティチェック
7. **並列実行の最適化**: 同時実行可能なタスクを特定して有効化
8. **シンプルに保つ**: orchestratorが解析・実行しやすい形式
