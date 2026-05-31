<h1 align="center">Hardmute</h1>

<p align="center">
  <b>execution without noise</b>
</p>

<p align="center">
  <img src="assets/images/hardmute.png" width="200" alt="Hardmute Logo">
</p>

<p align="center">
  <a href="#install">Install</a> •
  <a href="#modes">Modes</a> •
  <a href="#why-hardmute">Why</a> •
  <a href="#compatibility">Compatibility</a>
</p>

---

A lightweight execution protocol for AI agents. Hardmute removes output noise — narration, explanation, redundant comments — and delivers only signal. Your AI writes code instead of talking about writing code.

> AI that executes, not explains.

---

## Why Hardmute

LLMs waste tokens by default. Every response carries overhead: thinking out loud, explaining what it's about to do, restating what it just did. This costs tokens, increases latency, and fills up context windows fast.

Hardmute enforces a simple contract: **execute first, output only what matters.**

```
┌─────────────────────────────────────────────┐
│  Normal AI Response          157 tokens     │
│  "Sure! I'll create a PHP file for you.     │
│   Here's what I did: ..."                   │
├─────────────────────────────────────────────┤
│  Hardmute Response             5 tokens     │
│  ✓[index.php]                               │
└─────────────────────────────────────────────┘
```

**97% fewer output tokens. All budget goes to code.**

### What actually happens

When you silence the narration, the model's token budget shifts entirely to reasoning and code generation. It doesn't get "smarter" — it gets **focused**. Same developer, fewer meetings.

---

## Quick Demo

<table>
<tr>
<td width="50%">

**Without Hardmute**

```
Sure, I'll create a PHP file for you.
Here's a basic Hello World implementation:

<?php
echo "Hello World";
?>

This creates a simple PHP script that outputs
"Hello World" to the browser. You can run it
by placing it in your web server's document
root and navigating to it in your browser.
```

</td>
<td width="50%">

**With Hardmute**

```
✓[index.php]
```

</td>
</tr>
</table>

Same file created. One used 97% fewer tokens doing it.

---

## Install

### Mac / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/rawp-id/hardmute/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/rawp-id/hardmute/main/install.ps1 | iex
```

Interactive TUI installer — pick your agents, pick your skills, done.

Works with any agent that reads markdown skill files.

---

## Modes

Four composable modes. Each is a separate skill — only the one you call gets loaded.

### `/hardmute` — silent execution

Zero output. Execute, then signal done.

```
/hardmute create index.php that prints Hello World
```

```
✓[index.php]
```

---

### `/hardmute-info` — result + 2 lines

Execute + minimal context. Max 2 info lines.

```
/hardmute-info create a sqlite connection in php
```

```
req: pdo_sqlite in php.ini
✓[db.php]
```

---

### `/hardmute-detail` — result + how-to

Execute + usage guide. Max 5 lines.

```
/hardmute-detail create a flask hello world app
```

```
file: app.py
run: flask run
out: Hello World on http://localhost:5000
✓[app.py]
```

---

### `/hardmute-trace` — debug on failure

Silent on success. Trace only on failure.

```
/hardmute-trace deploy to production
```

```
✓[deployed]
```

```
# on failure:
write_file → fail
err: permission denied /var/www
fix: chmod 755 /var/www
```

---

### `/hardmute-think` — brainstorming

No code, no execution. Pure ideas in compressed format. Responds in your language.

```
/hardmute-think best approach for auth in mobile app?
```

```
→ OAuth2 + PKCE, not implicit flow
→ token in secure storage (Keychain/Keystore)
→ refresh token rotation, revoke on logout
→ biometric unlock → decrypt local token
⚠ avoid: localStorage/SharedPreferences plain
? need offline access? affects architecture
```

---

## How It Works

Each mode is a self-contained `SKILL.md` file. No shared core, no global state, no runtime dependency.

```
/hardmute       → loads hardmute/SKILL.md only
/hardmute-trace → loads hardmute-trace/SKILL.md only
```

Scope is **per-message**. No bleedover. No persistent mode. Call it when you need it.

### Enforcement

Hardmute uses aggressive instruction layering to override model verbosity:

- Explicit WRONG/RIGHT examples so models have concrete reference
- Model-specific override section that outranks default helpfulness training
- Zero-tolerance rules — any prose outside the format = protocol violation

Tested against verbose models (Claude Opus, GPT-4) and tuned to keep them silent.

---

## Design Principles

| # | Principle | Meaning |
|---|-----------|---------|
| 1 | Execution > explanation | Invoke tools first, speak after |
| 2 | Signal > noise | Output only what code can't show |
| 3 | Per-message scope | No persistent state, no global mode |
| 4 | Universal | Works across models and agents |
| 5 | Composable | Pick the mode that fits the task |

---

## Code Style

When hardmute writes or edits code:

- Comments: max 3 words, only when not obvious
- Blank lines: max 1 between blocks
- No section separators
- No block docstrings unless requested

---

## Compatibility

| Platform | Status |
|----------|--------|
| Claude Code | ✓ |
| Cursor | ✓ |
| Windsurf | ✓ |
| OpenAI Codex | ✓ |
| Gemini CLI | ✓ |
| Any markdown-skill agent | ✓ |

---

## Hardmute vs Caveman

[Caveman](https://github.com/JuliusBrussee/caveman) compresses AI narration into terse speech (~75% saving). Hardmute eliminates narration entirely.

|                | Caveman | Hardmute |
|----------------|---------|----------|
| Approach | Compress output | Silence output |
| Best for | Explanation tasks | Execution tasks |
| Output style | Terse language | Signal only |
| When it speaks | Always (compressed) | Only when required |
| Token saving | ~75% | ~97% |

They compose well — hardmute uses caveman-style formatting for the rare cases it must communicate (errors, clarifications).

---

## License

[MIT](LICENSE)
