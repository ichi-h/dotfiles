{
  name = "investigator";
  description = "問題の調査・根本原因分析を行うエージェント。エラー・バグ・パフォーマンス問題・設定問題の原因究明が必要なときに有効である。このエージェントはエラー調査・根本原因特定・コードベース解析・ログ調査・設定検査・web検索・GitHub Issues確認・解決策提案が可能であり、調査は web-research / codebase-analysis / env-config / synthesis の4タイプで実施される。";
  claude = {
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
      "bash"
      "grep"
      "glob"
      "view"
      "web_search"
      "github-mcp-server-*"
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
      "bash"
      "grep"
      "glob"
      "view"
      "web_search"
      "github-mcp-server-*"
    ];
    model = null;
  };
}
