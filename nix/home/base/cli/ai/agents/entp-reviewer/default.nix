{
  name = "entp-reviewer";
  description = "ENTP型のレビュアー。代替案・トレードオフ・見落としリスクの視点でコードをレビューする。「より良い別アプローチがないか」「見落としているリスクはないか」「トレードオフを整理したい」ときなど、設計・実装の妥当性を批判的に検討したいときに有効である。このエージェントは代替案提案、トレードオフの明確化、見落とされたリスクの指摘、創造的なアプローチの提案ができる。";
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
