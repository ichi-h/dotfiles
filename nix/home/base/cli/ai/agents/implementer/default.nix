{
  name = "implementer";
  description = "コード実装・設定変更・テスト作成を担当するタスク実行エージェント。コーディング・ファイル変更・設定更新・テスト実装・ドキュメント作成などの具体的な実装タスクを委譲したいときに有効である。このエージェントはコードの実装・修正・リファクタリング、設定ファイルの作成・変更、テスト作成・実行、フォーマッター・リンター実行、ドキュメント作成・更新を行うことができる。一方で、設計判断・アーキテクチャ選定が必要なとき、問題の根本原因を調査するときは適切ではない。";
  claude = {
    tools = [
      "mcp__serena__read_memory"
      "mcp__serena__list_memories"
      "mcp__serena__find_file"
      "mcp__serena__list_dir"
      "mcp__serena__search_for_pattern"
      "mcp__serena__get_symbols_overview"
      "mcp__serena__find_symbol"
      "mcp__serena__find_referencing_symbols"
      "mcp__serena__replace_symbol_body"
      "mcp__serena__replace_content"
      "mcp__serena__insert_after_symbol"
      "mcp__serena__insert_before_symbol"
      "mcp__serena__rename_symbol"
      "mcp__serena__activate_project"
      "mcp__serena__check_onboarding_performed"
      "mcp__serena__onboarding"
      "mcp__serena__initial_instructions"
      "mcp__serena__think_about_collected_information"
      "mcp__serena__think_about_task_adherence"
      "mcp__serena__think_about_whether_you_are_done"
      "Bash"
      "Read"
      "Write"
      "Edit"
    ];
    model = null;
  };
  copilot = {
    tools = [
      "serena/read_memory"
      "serena/list_memories"
      "serena/find_file"
      "serena/list_dir"
      "serena/search_for_pattern"
      "serena/get_symbols_overview"
      "serena/find_symbol"
      "serena/find_referencing_symbols"
      "serena/replace_symbol_body"
      "serena/replace_content"
      "serena/insert_after_symbol"
      "serena/insert_before_symbol"
      "serena/rename_symbol"
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
      "create"
      "edit"
    ];
    model = null;
  };
}
