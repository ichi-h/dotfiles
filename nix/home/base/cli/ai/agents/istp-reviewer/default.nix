{
  name = "istp-reviewer";
  description = "ISTP型のレビュアー。実用性・実装品質の視点でコードをレビューする。「実際に動くか」「この変更は本当に必要か」「実装に無駄や問題がないか」を確かめたいときに有効である。このエージェントは実装品質・動作可能性・不要な変更・コードの簡潔さの観点からのレビューと指摘が可能である。";
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
