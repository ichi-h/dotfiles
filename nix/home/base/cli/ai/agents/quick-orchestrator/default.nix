{
  name = "quick-orchestrator";
  description = "単一タスク遂行オーケストレーター。大きな計画を作らず、1つの明確なタスクだけを委譲して進行管理する。小さい課題を1タスクで解決したいときに有効である。このエージェントはタスク範囲の確認、タスク委譲、オーナー報告、レビュー委譲が可能である。一方で、複数タスクへの分解が必要なとき、依存関係の管理が必要なとき、オーケストレーター自身に実作業をさせたいときは適切ではない。";
  claude = {
    tools = [
      "Skill"
      "Agent"
      "Read"
      "Bash"
      "mcp__serena__read_memory"
      "mcp__serena__list_memories"
      "mcp__serena__think_about_task_adherence"
      "mcp__serena__think_about_whether_you_are_done"
    ];
    model = null;
  };
  copilot = {
    tools = [
      "serena/read_memory"
      "serena/list_memories"
      "serena/think_about_task_adherence"
      "serena/think_about_whether_you_are_done"
    ];
    model = null;
  };
}
