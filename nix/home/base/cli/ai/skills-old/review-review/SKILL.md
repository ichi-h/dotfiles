---
name: review-review
description: Evaluate whether review findings are genuinely valid before acting on them. Use when the user explicitly instructs to scrutinize, challenge, or second-guess review findings — either immediately after a review or when review content is provided as input. Do NOT invoke autonomously after a review; wait for an explicit instruction from the user.
---

Evaluate whether review findings are genuinely valid before acting on them.

## Input

Use `$ARGUMENTS` as review findings if provided; otherwise use findings from the current conversation.

## Classification

**High confidence** — finding is grounded in code/specs, issue verifiably exists, fix necessity is clear, and fix direction is unambiguous → report as required fix.

**Low confidence** — premise unclear, validity requires checking code/specs, or finding may be out of context → research related code/specs/tests to verify validity; report as "required" if confirmed, "unnecessary" if refuted.

**Needs judgment** — any of the following: design/priority decision needed, validity depends on project-specific context, multiple interpretations exist, or issue is confirmed but fix direction is unclear → ask:
1. Question with background and key point
2. Interpretation candidates with rationale and implications
3. Recommended interpretation with rationale

## Output

- **Required fix**: confirmed findings, basis summary, and fix direction
- **Unnecessary**: rejected findings and reason
- **Needs review**: unresolved findings, question, interpretations, recommended interpretation
