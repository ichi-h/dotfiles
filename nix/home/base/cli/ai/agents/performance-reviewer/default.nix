{
  name = "performance-reviewer";
  description = "パフォーマンス専門レビュアー。SQLクエリ効率・不要なループや計算量・メモリリークを専門とする。「N+1クエリが発生していないか」「アルゴリズムの計算量に問題がないか」「メモリを不必要に確保していないか」を確認したいときに有効。システムに実質的な影響を与えるパフォーマンス問題のみを報告する。レビュー対象ファイルは呼び出し元から明示して渡すこと。対象が不明確な場合はレビュー開始前に確認すること。";
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
