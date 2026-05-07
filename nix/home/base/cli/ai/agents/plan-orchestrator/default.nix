{
  name = "plan-orchestrator";
  description = "計画オーケストレーター。ユーザーの要望を整理し、承認用の計画を立案する。新しい課題・機能要望・改善要求など、まず計画から進めるべきときに有効である。このエージェントはヒアリング・計画立案・タスク分解・計画のセキュリティチェックが可能である。";
  claude = {
    tools = [
      "Agent"
      "AskUserQuestion"
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
