---
name: investigation
description: investigatorへの調査委譲パターンを定義します。調査タイプの分類、分解手順、並列化戦略、委譲プロンプトテンプレートを提供します。
---

# 調査委譲スキル

## 調査タイプ

investigatorへの委譲は必ず以下の4タイプのいずれかとして行う。「全部調べて」という複合的な委譲は禁止。

| タイプ | 用途 | 主なツール |
|---|---|---|
| `web-research` | エラーのweb検索・ライブラリChangelog・GitHub Issues確認 | `web_search`, `github-mcp-server-*` |
| `codebase-analysis` | ソースコード解析・依存関係追跡・git履歴確認 | `serena/*`, `grep`, `glob`, `bash` |
| `env-config` | 設定ファイル・環境変数・ログ・パーミッション検査 | `bash`, `view`, `grep` |
| `synthesis` | 並列調査結果を統合し根本原因を特定・解決策を提案 | なし（推論のみ） |

## 分解手順

1. 問題を「何がわからないか」の軸で分解する
2. 各不明点を上記タイプに分類する
3. タイプごとに独立した investigator タスクを生成して**並列委譲**する
4. すべての並列調査完了後、結果を添えて `synthesis` タスクを**順次委譲**する

## 並列化戦略

```
並列実行: web-research + codebase-analysis + env-config（該当タイプのみ）
     ↓（全完了後）
順次実行: synthesis（並列調査の結果をすべてプロンプトに含める）
```

- `web-research` / `codebase-analysis` / `env-config` は互いに独立しており常に並列実行できる
- `synthesis` は並列調査の結果を入力として必要とするため必ず後続で実行する
- 問題が明らかに1タイプで解決する場合は並列化不要（synthesis も省略可）

## 委譲プロンプトテンプレート

各 investigator タスクに必ず以下の形式を含める:

```
タイプ: [web-research | codebase-analysis | env-config | synthesis]
調査対象: [具体的な対象（URL、ファイルパス、エラーメッセージなど）]
調査内容: [何を明らかにするか（単一の問い）]
返却形式: [発見した情報・コード箇所・設定値など]
スコープ外: [触れてはいけない領域]
```

### タイプ別の例

**web-research**:
```
タイプ: web-research
調査対象: nix 2.18 → 2.24
調査内容: 破壊的変更の有無
返却形式: 該当 Changelog 箇所・URL
スコープ外: コードベースの中身
```

**codebase-analysis**:
```
タイプ: codebase-analysis
調査対象: flake.nix
調査内容: 直近の変更差分と変更箇所
返却形式: 変更コミット・ファイル内の該当行
スコープ外: web検索・環境設定
```

**env-config**:
```
タイプ: env-config
調査対象: ~/.config/nix/nix.conf
調査内容: experimental-features の設定値確認
返却形式: 設定値・異常箇所
スコープ外: web検索・ソースコード
```

**synthesis**:
```
タイプ: synthesis
問題の説明: [元の問題の説明]
並列調査結果:
  - web-research 結果: [結果]
  - codebase-analysis 結果: [結果]
  - env-config 結果: [結果]
調査内容: 上記結果を統合し根本原因を特定。解決策を実装可能な粒度で提案
返却形式: investigator 標準報告フォーマット（根本原因・根拠・解決案）
```

## investigator のスコープ厳守ルール

investigator は委譲されたタイプのスコープ内のみで調査を行う:

| タイプ | 禁止事項 |
|---|---|
| `web-research` | コードベースを調べること |
| `codebase-analysis` | web検索・設定ファイルの中身 |
| `env-config` | web検索・ソースコード |
| `synthesis` | 追加の情報収集（与えられた結果のみで判断） |

スコープ外の情報が必要と判断した場合は:
1. 現在の調査タイプで判明したことを報告する
2. 「追加で`[タイプ]`による調査が推奨される」と明記してオーケストレーターに判断を委ねる
