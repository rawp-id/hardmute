<h1 align="center">Hardmute</h1>

<p align="center">
  <b>execution without noise</b>
</p>

<p align="center">
  <img src="assets/images/hardmute.png" width="200" alt="Hardmute Logo">
</p>

A lightweight execution protocol for AI agents and LLMs. Hardmute removes output noise narration, explanation, redundant comments and delivers only signal. Built for Claude Code, Cursor, and any agent that supports skill/instruction files.

> AI that executes, not explains.

---

## Why Hardmute

LLMs are verbose by default. Every response carries overhead: thinking out loud, explaining what it's about to do, restating what it just did. This costs tokens, increases latency, and fills up context windows fast.

Hardmute enforces a simple contract: **execute first, output only what matters.**

| mode     | output tokens |
| -------- | ------------- |
| normal   | 157           |
| hardmute | 5             |

**97.5% fewer output tokens. 1 fewer model call.**

---

## Quick Demo

Normal agent:

Sure, I will create a PHP file for you...

Hardmute:

✓ [index.php]

---

## Install

Copy the skill folders into your agent's skills directory:

```bash
# Claude Code
cp -r hardmute ~/.claude/skills/
cp -r hardmute-info ~/.claude/skills/
cp -r hardmute-detail ~/.claude/skills/
cp -r hardmute-trace ~/.claude/skills/
```

Works with any agent that reads instruction/skill markdown files: Claude Code, Cursor, Windsurf, OpenAI Codex, and others.

---

## Modes

hardmute ships as four composable modes. Each is a separate skill only the one you call gets loaded.

### `/hardmute` silent execution

Zero output. Execute, then signal done.

```
/hardmute create index.php that prints Hello World
```

```
✓ [index.php]
```

---

### `/hardmute-info` result + 2 lines

Execute + minimal context. Max 2 info lines.

```
/hardmute-info create a sqlite connection in php
```

```
req: pdo_sqlite in php.ini
✓ [db.php]
```

---

### `/hardmute-detail` result + how-to

Execute + usage guide. Max 5 lines.

```
/hardmute-detail create a flask hello world app
```

```
file: app.py
run: flask run
out: Hello World on http://localhost:5000
✓ [app.py]
```

---

### `/hardmute-trace` debug on failure

Execute + trace only on failure. Silent on success.

```
/hardmute-trace deploy to production
```

```
# on success
✓ [deployed]

# on failure
write_file → fail
err: permission denied /var/www
fix: chmod 755 /var/www
```

---

## How It Works

Each mode is a self-contained SKILL.md file. No shared core, no global state. When you prefix a message with `/hardmute`, only that skill file loads no other context overhead.

```
/hardmute → loads hardmute/SKILL.md only
/hardmute-trace → loads hardmute-trace/SKILL.md only
```

Scope is per-message. No bleedover to other conversations or skills.

---

## Design Principles

1. **Execution > explanation** invoke tools first, speak after
2. **Signal > noise** output only what code can't show
3. **Per-message scope** no persistent state, no global mode
4. **Universal** works across models and agents
5. **Composable** pick the mode that fits the task

---

## Code Style

When hardmute writes or edits code:

- Comments: max 3 words, only when not obvious from code
- Blank lines: max 1 between blocks, never consecutive
- No section separators (`─────`, `====`)
- No block docstrings unless explicitly requested

---

## Compatibility

| platform                 | supported |
| ------------------------ | --------- |
| Claude Code              | ✓         |
| Cursor                   | ✓         |
| Windsurf                 | ✓         |
| OpenAI Codex             | ✓         |
| Any markdown-skill agent | ✓         |

---

## Hardmute vs Caveman

[Caveman](https://github.com/JuliusBrussee/caveman) compresses AI _narration_ into terse, caveman-style speech (~75% output saving on heavy narration tasks). hardmute _eliminates_ narration entirely.

Different tools, different jobs:

|                | caveman             | hardmute           |
| -------------- | ------------------- | ------------------ |
| approach       | compress output     | silence output     |
| best for       | explanation tasks   | execution tasks    |
| output style   | terse language      | signal only        |
| when it speaks | always (compressed) | only when required |

They work well together hardmute uses caveman-style formatting for the rare cases it must communicate (errors, clarifications).

---

## License

MIT
