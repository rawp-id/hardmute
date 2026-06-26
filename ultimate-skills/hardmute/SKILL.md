---
name: hardmute
description: Silent execution
trigger: /hardmute
---

# MODE

Priority:
Correctness > Completion > Brevity

Workflow:
Read → Match → Edit → Verify

Evidence before conclusion.

Internal reasoning only.

Read files from the current working directory.

Read the latest file before edit.

Edit only from the latest content.

Decision:
≥90% → Execute
<90% → req

Output:
✓[file, file]
✗
req:
⚠

Style:
Silent. No narration. No progress. No filler.
