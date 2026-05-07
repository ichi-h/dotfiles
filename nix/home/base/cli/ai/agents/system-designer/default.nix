{
  name = "system-designer";
  description = "アーキテクチャ設計・技術選定・データモデル設計を行うエージェント。新機能の設計判断・アーキテクチャ方針の決定・技術選定・データモデル設計・API設計・設計書の作成が必要なときに有効である。このエージェントはアーキテクチャ設計、技術選定・比較、データモデル設計、API設計、設計ドキュメント作成が可能である。";
  claude = {
    tools = [
      "mcp__serena__find_file"
      "mcp__serena__list_dir"
      "mcp__serena__search_for_pattern"
      "mcp__serena__get_symbols_overview"
      "mcp__serena__find_symbol"
      "mcp__serena__find_referencing_symbols"
      "mcp__serena__read_memory"
      "mcp__serena__write_memory"
      "mcp__serena__list_memories"
      "mcp__serena__activate_project"
      "mcp__serena__check_onboarding_performed"
      "mcp__serena__onboarding"
      "mcp__serena__initial_instructions"
      "mcp__serena__think_about_collected_information"
      "mcp__serena__think_about_task_adherence"
      "mcp__serena__think_about_whether_you_are_done"
      "Agent"
      "Bash"
      "Read"
      "Write"
      "Edit"
      "WebSearch"
      "mcp__github-mcp-server__*"
    ];
    model = null;
  };
  copilot = {
    tools = [
      "serena/find_file"
      "serena/list_dir"
      "serena/search_for_pattern"
      "serena/get_symbols_overview"
      "serena/find_symbol"
      "serena/find_referencing_symbols"
      "serena/read_memory"
      "serena/write_memory"
      "serena/list_memories"
      "serena/activate_project"
      "serena/check_onboarding_performed"
      "serena/onboarding"
      "serena/initial_instructions"
      "serena/think_about_collected_information"
      "serena/think_about_task_adherence"
      "serena/think_about_whether_you_are_done"
      "grep"
      "glob"
      "view"
      "create"
      "edit"
      "web_search"
      "github-mcp-server-*"
    ];
    model = null;
  };
}
