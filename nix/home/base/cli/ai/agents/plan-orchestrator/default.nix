{
  name = "plan-orchestrator";
  description = "計画オーケストレーター。ユーザーの要望を整理し、承認用の計画を立案する。新しい課題・機能要望・改善要求など、まず計画から進めるべきときに有効である。このエージェントはヒアリング・計画立案・タスク分解・計画のセキュリティチェックが可能である。";
  claude = {
    tools = [
      "task"
      "ask_user"
      "read_agent"
      "list_agents"
      "serena/read_memory"
      "serena/list_memories"
      "serena/think_about_task_adherence"
      "serena/think_about_whether_you_are_done"
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
