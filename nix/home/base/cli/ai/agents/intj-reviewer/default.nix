{
  name = "intj-reviewer";
  description = "INTJ型のレビュアー。設計整合性・長期保守性の視点でコードをレビューする。「設計の一貫性」「アーキテクチャへの影響」「長期的な保守性」を確かめたいときなど、システム全体への影響が大きい変更のレビューにおいて有効である。このエージェントは設計整合性・将来の保守性・根本原因・アーキテクチャへの影響の観点からのレビューおよび指摘が可能である。";
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
