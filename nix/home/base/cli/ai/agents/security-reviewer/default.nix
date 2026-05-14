{
  name = "security-reviewer";
  description = "セキュリティ専門レビュアー。認証・認可・インジェクション攻撃・XSS/CSRF・機密情報・セキュアな通信・脆弱な依存関係を専門とする。セキュリティ脆弱性の発見・評価が必要なときに有効。SQLインジェクション・認証バイパス・APIキーのハードコード・既知CVEを持つライブラリの使用など、悪用されると深刻な被害につながる問題を検出する。レビュー対象ファイルは呼び出し元から明示して渡すこと。対象が不明確な場合はレビュー開始前に確認すること。";
  claude = {
    tools = [
      "mcp__serena__list_memories"
      "mcp__serena__read_memory"
      "mcp__serena__think_about_collected_information"
      "mcp__serena__think_about_task_adherence"
      "mcp__serena__think_about_whether_you_are_done"
      "Bash"
      "Read"
      "Skill"
    ];
    model = null;
  };
  copilot = {
    tools = [
      "serena/list_memories"
      "serena/read_memory"
      "serena/think_about_collected_information"
      "serena/think_about_task_adherence"
      "serena/think_about_whether_you_are_done"
      "grep"
      "glob"
      "view"
      "git/git_diff_staged"
      "git/git_diff_unstaged"
      "git/git_status"
    ];
    model = null;
  };
}
