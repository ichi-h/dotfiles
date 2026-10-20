#!/usr/bin/env bash
# npx skills のインストール状態を、宣言的な設定 (spec) に同期する。
#
# 設計方針:
#   - spec を「あるべき状態」、`npx skills ls -g --json` の結果を「現在の状態」とし、
#     差分だけを add / remove する。
#   - エージェント集合は `npx skills ls` からは正確に取得できないため、
#     前回同期した内容を state.json に保存し、集合が変わった場合だけ
#     「全エージェントから削除 → 指定エージェントへ再追加」する。
#   - source が null のスキル (Home Manager が管理するもの) は削除対象にしない。
#
# 終了コード: 0 = 成功, 1 = 一部失敗, 2 = 設定不備
set -uo pipefail

usage() {
  cat <<'EOF'
使い方: agent-skills-manager [オプション]

宣言的な設定 (AGENT_SKILLS_MANAGER_SPEC) と現在のインストール状態を比較し、
不足しているスキルを追加、不要になったスキルを削除します。

オプション:
  --dry-run   変更せず、実行予定の操作だけを表示する
  --verbose   実行する npx skills の出力を表示する
  -h, --help  このヘルプを表示する

環境変数:
  AGENT_SKILLS_MANAGER_SPEC  設定 JSON のパス (Home Manager が設定する)
EOF
}

spec="${AGENT_SKILLS_MANAGER_SPEC:-}"
dry_run=0
verbose=0
while [ $# -gt 0 ]; do
  case "$1" in
  --dry-run) dry_run=1 ;;
  --verbose | -v) verbose=1 ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "agent-skills-manager: 不明な引数: $1" >&2
    exit 2
    ;;
  esac
  shift
done

if [ -z "$spec" ] || [ ! -f "$spec" ]; then
  echo "agent-skills-manager: AGENT_SKILLS_MANAGER_SPEC が未設定、またはファイルが存在しません" >&2
  exit 2
fi

npx_pkg="$(jq -r '.npxPackage' "$spec")"
prune="$(jq -r 'if .prune == null then true else .prune end' "$spec")"

log() { printf 'agent-skills-manager: %s\n' "$*" >&2; }
failures=0

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/agent-skills-manager"
state_file="$state_dir/state.json"
mkdir -p "$state_dir"

# npx のキャッシュや更新通知が $HOME 直下を汚さないようにする。
export npm_config_cache="${XDG_CACHE_HOME:-$HOME/.cache}/agent-skills-manager/npm"
export npm_config_fund=false
export npm_config_audit=false
export npm_config_update_notifier=false
mkdir -p "$npm_config_cache"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# npx skills の呼び出し。ネットワークアクセスを伴う。
skills() { npx --yes "$npx_pkg" "$@"; }

# 進捗表示 (スピナーや枠線) が混ざるため、先頭の "[" 以降だけを JSON として扱う。
json_part() { sed -n '/^\[/,$p'; }

run_skill() {
  if [ "$dry_run" -eq 1 ]; then
    log "[dry-run] npx $npx_pkg $*"
    return 0
  fi
  if [ "$verbose" -eq 1 ]; then
    skills "$@"
  else
    skills "$@" >/dev/null 2>&1
  fi
}

# ---------------------------------------------------------------------------
# あるべき状態
# ---------------------------------------------------------------------------
# "リポジトリ, スキル, エージェント集合" の組に展開する。
# agents を省略した場合は "*" (全エージェント) とみなす。
jq -r '
  .sources[]
  | (.repository) as $repo
  | (.agents // ["*"]) as $agents
  | (if ($agents | index("*")) then "*" else ($agents | join(",")) end) as $key
  | .skills[] | [$repo, ., $key] | @tsv
' "$spec" >"$tmp/desired.tsv"

if [ -s "$tmp/desired.tsv" ]; then
  duplicates="$(cut -f2 "$tmp/desired.tsv" | sort | uniq -d | tr '\n' ' ')"
  if [ -n "${duplicates// /}" ]; then
    # 同名スキルが複数リポジトリにあると差分判定が壊れるため中断する。
    log "同じスキル名が複数のリポジトリで定義されています: $duplicates"
    exit 2
  fi
fi
cut -f2 "$tmp/desired.tsv" | sort -u >"$tmp/desired-names.txt"

# 設定が空で、まだ一度も同期していない場合は何もしない
# (スイッチのたびに npx を起動してネットワークへ取りに行くのを避ける)。
if [ ! -s "$tmp/desired-names.txt" ] && [ ! -f "$state_file" ]; then
  log "管理対象のスキルが未定義のため、同期をスキップしました"
  exit 0
fi

# ---------------------------------------------------------------------------
# 現在のインストール状態
# ---------------------------------------------------------------------------
skills ls -g --json 2>/dev/null | json_part >"$tmp/installed.raw.json"
if ! jq -e 'type == "array"' "$tmp/installed.raw.json" >/dev/null 2>&1; then
  log "現在のインストール状態を取得できませんでした。同期を中止します。"
  exit 1
fi
jq '[.[] | {name, source, sourceUrl}]' "$tmp/installed.raw.json" >"$tmp/installed.json"

# ---------------------------------------------------------------------------
# 差分の算出
# ---------------------------------------------------------------------------
prev_field() { # skill field -> 値 (未管理なら空)
  [ -f "$state_file" ] || return 0
  jq -r --arg n "$1" --arg f "$2" '.skills[$n][$f] // empty' "$state_file" 2>/dev/null
}

prev_agents() { # skill -> "*" | "a,b" | "" (未管理)
  [ -f "$state_file" ] || return 0
  jq -r --arg n "$1" '
    (.skills[$n] // empty)
    | if . == null or .agents == null then "*" else (.agents | join(",")) end
  ' "$state_file" 2>/dev/null | grep -v '^$' || true
}

is_installed() { # skill -> 0/1
  jq -e --arg n "$1" 'any(.[]; .name == $n)' "$tmp/installed.json" >/dev/null 2>&1
}

installed_source() { # skill -> sourceUrl | ""
  jq -r --arg n "$1" '(.[] | select(.name == $n) | .sourceUrl) // empty' "$tmp/installed.json" 2>/dev/null | head -1
}

: >"$tmp/remove.txt"
: >"$tmp/add.tsv"

while IFS=$'\t' read -r repo name agents; do
  [ -n "$name" ] || continue

  if ! is_installed "$name"; then
    printf '%s\t%s\t%s\n' "$repo" "$agents" "$name" >>"$tmp/add.tsv"
    continue
  fi

  # 前回の同期記録がない場合は、この設定管理下になかったスキル。
  # 同じリポジトリ由来であれば現状を採用し、異なる場合だけ入れ直す。
  if [ -z "$(prev_field "$name" repository)" ]; then
    current_source="$(installed_source "$name")"
    case "$current_source" in
    *"/$repo.git" | *"/$repo") ;;
    *)
      printf '%s\n' "$name" >>"$tmp/remove.txt"
      printf '%s\t%s\t%s\n' "$repo" "$agents" "$name" >>"$tmp/add.tsv"
      ;;
    esac
    continue
  fi

  # リポジトリまたはエージェント集合が変わっていれば入れ直す。
  prev_repo="$(prev_field "$name" repository)"
  prev_agent_list="$(prev_agents "$name")"
  if [ "$prev_repo" != "$repo" ] || [ "$prev_agent_list" != "$agents" ]; then
    printf '%s\n' "$name" >>"$tmp/remove.txt"
    printf '%s\t%s\t%s\n' "$repo" "$agents" "$name" >>"$tmp/add.tsv"
  fi
done <"$tmp/desired.tsv"

# 削除されたスキル。source が null のものは Home Manager 管理なので触らない。
if [ "$prune" = "true" ]; then
  jq -r '.[] | select(.source != null) | .name' "$tmp/installed.json" |
    while IFS= read -r name; do
      [ -n "$name" ] || continue
      grep -Fxq -- "$name" "$tmp/desired-names.txt" || printf '%s\n' "$name"
    done >>"$tmp/remove.txt"
fi

sort -u -o "$tmp/remove.txt" "$tmp/remove.txt"
sort -u -o "$tmp/add.tsv" "$tmp/add.tsv"

# ---------------------------------------------------------------------------
# 実行: 削除を先に行い、そのあと追加する
# ---------------------------------------------------------------------------
remove_skills() { # skill...
  local -a args=()
  local s
  for s in "$@"; do args+=(-s "$s"); done
  log "- 削除: $*"
  if ! run_skill remove -g -y "${args[@]}"; then
    failures=$((failures + 1))
    log "警告: 削除に失敗しました: $*"
  fi
}

add_skills() { # repository agentsKey skill...
  local repo="$1" agents="$2"
  shift 2
  local -a args=() ids=()
  local s a
  for s in "$@"; do args+=(-s "$s"); done
  if [ "$agents" = "*" ]; then
    args+=(-a "*")
    log "+ 追加: ${repo} (すべてのエージェント): $*"
  else
    IFS=',' read -r -a ids <<<"$agents"
    for a in "${ids[@]}"; do args+=(-a "$a"); done
    log "+ 追加: ${repo} (${agents}): $*"
  fi
  if ! run_skill add "$repo" -g -y "${args[@]}"; then
    # 全エージェント指定では、グローバル非対応のエージェント (eve など) が
    # 失敗扱いになることがあるため、警告に留めて続行する。
    if [ "$agents" = "*" ]; then
      log "警告: 一部のエージェントには追加できませんでした: ${repo} $*"
    else
      failures=$((failures + 1))
      log "警告: 追加に失敗しました: ${repo} ($agents) $*"
    fi
  fi
}

if [ -s "$tmp/remove.txt" ]; then
  mapfile -t remove_list <"$tmp/remove.txt"
  if [ ${#remove_list[@]} -gt 0 ]; then
    remove_skills "${remove_list[@]}"
  fi
fi

if [ -s "$tmp/add.tsv" ]; then
  mapfile -t add_lines <"$tmp/add.tsv"
  declare -A add_groups=()
  for line in "${add_lines[@]}"; do
    # 同一リポジトリ・同一エージェント集合のものは 1 回のコマンドにまとめる。
    key="${line%$'\t'*}"
    add_groups[$key]+=" ${line##*$'\t'}"
  done
  for key in "${!add_groups[@]}"; do
    repo="${key%%$'\t'*}"
    agents="${key#*$'\t'}"
    # shellcheck disable=SC2086
    add_skills "$repo" "$agents" ${add_groups[$key]}
  done
fi

# ---------------------------------------------------------------------------
# 次回の差分判定用に、今回の設定を状態として保存する
# ---------------------------------------------------------------------------
if [ "$dry_run" -eq 0 ]; then
  jq '{
    version: 1,
    skills: (
      [.sources[] as $s
        | ($s.agents // ["*"]) as $a
        | ($a | if index("*") then null else . end) as $agents
        | $s.skills[]
        | {key: ., value: {repository: $s.repository, agents: $agents}}]
      | from_entries
    )
  }' "$spec" >"$state_file.tmp" && mv "$state_file.tmp" "$state_file"
fi

if [ "$failures" -gt 0 ]; then
  log "${failures} 件の処理に失敗しました"
  exit 1
fi
exit 0
