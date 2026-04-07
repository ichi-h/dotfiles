# decouple-agents-and-skills-phase2

status: completed

## 概要

前フェーズ（decouple-agents-and-skills）でエージェントとスキルの依存関係を大幅に解消したが、
残存する3種の問題を修正する。具体的には①reviewer agentsがreviewスキル名を直接参照している問題、
②agent-delegationスキルにオーケストレーターのポリシーが混入している問題、
③backlog-managementスキルのテンプレートとbacklog-manager agentのテンプレートが乖離している問題を解消する。

## タスク

- [x] istp-reviewer・intj-reviewer・entp-reviewer のワークフローからスキル名参照を除去する (task-p3q8)
  - agent: implementer
- [x] agent-delegation/SKILL.md のエージェントカタログから「自動実行」ポリシー記述を削除する (task-r7s2)
  - agent: implementer
- [x] agent-delegation/SKILL.md の investigatorへの委譲基準セクションを削除し、orchestrator.agent.md に統合する (task-t1u6)
  - agent: implementer
  - dependent on: task-r7s2
- [x] backlog-management/SKILL.md のタスク行テンプレートに agent フィールドを追加して backlog-manager agent と同期する (task-w4x9)
  - agent: implementer
- [x] 上記変更をコードレビューする (task-y5z3)
  - agent: istp-reviewer
  - dependent on: task-p3q8, task-r7s2, task-t1u6, task-w4x9
