{
  name = "orchestrator";
  description = "計画遂行オーケストレーター。承認済みの計画に含まれるタスクだけを委譲して進行管理する。このエージェントは承認済みの計画（バックログ）があり、タスクを順序・依存関係に従ってサブエージェントに委譲しながら完了させたいときに有効である。計画確認・計画修正の提案・サブエージェントへのタスク委譲（並列含む）・並列レビュー委譲が可能である。一方で、計画が存在しない・未承認のとき、単一タスクを素早く片付けたいときは適切ではない。";
  claude = {
    tools = [
      "sql"
      "skill"
      "task"
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
