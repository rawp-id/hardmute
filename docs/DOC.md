# **hardmute**

**Tagline:** _execution without noise_

---

## 1. Overview

**hardmute** is an output control layer for AI agents that:

- removes noise (unnecessary explanations)
- prioritizes execution
- significantly reduces token usage

> **AI that executes, not explains.**

---

## 2. Problem

LLMs waste tokens by default:

- narration
- repetition
- verbose explanation

Impact:

- higher cost
- increased latency
- context fills up fast

---

## 3. Solution

hardmute = **execution-first protocol**

```text
input → execute → minimal output
```

---

## 4. Core Concept

Visual = **pulse cut by a line**

Meaning:

- pulse = output / signal
- cut = remove noise

Result:

> **clean signal only**

---

## 5. Modes (hardmute Family)

### 🔹 `/hardmute`

- silent execution
- zero output except signal

```text
✓[index.php]
```

---

### 🔹 `/hardmute-info`

- result + minimal context
- max 5 bullets (WHAT/WHY/WHEN/HOW)

```text
req: pdo_sqlite in php.ini
✓[db.php]
```

---

### 🔹 `/hardmute-detail`

- result + usage guide
- output: Context, Implementation, Example, Caveat

```text
file: app.py
run: flask run
out: Hello World on http://localhost:5000
✓[app.py]
```

---

### 🔹 `/hardmute-trace`

- silent on success
- trace only on failure

```text
✓[deployed]

# on failure:
write_file → fail
err: permission denied /var/www
fix: chmod 755 /var/www
```

---

### 🔹 `/hardmute-think`

- brainstorm only, no write
- dense bullets, responds in user's language

```text
→ OAuth2 + PKCE, not implicit flow
→ token in secure storage
⚠ avoid: localStorage plain
```

---

## 6. Skill Versions

### Standard

- Full rules, verbose enforcement
- Explicit instruction layering
- More sections, more guardrails
- Source: `skills/`

### Ultimate

- Lightweight
- Core: Priority → Workflow → Evidence → Decision
- Minimal sections, same enforcement
- Source: `ultimate-skills/`

**Priority (Ultimate):** Correctness > Completion > Brevity

**Workflow (Ultimate):** Read → Match → Edit → Verify

---

## 7. Output Contract

| Signal | Meaning |
|--------|---------|
| `✓[file]` | Success |
| `✗ error` | Failure |
| `req: question?` | Missing info (confidence < 90%) |
| `⚠ action — confirm? y/n` | Destructive action |

---

## 8. Design Principles

1. **Execution > explanation**
2. **Signal > noise**
3. **Per-message scope** — no persistent state
4. **Universal** — works across models
5. **Composable** — pick the mode that fits

---

## 9. Flow

```text
task
→ hardmute execute
→ success → ✓[file]
→ fail    → ✗ error
→ trace   → /hardmute-trace
→ think   → /hardmute-think
```

---

## 10. Architecture

```text
skills/               ← Standard version
  hardmute/SKILL.md
  hardmute-info/SKILL.md
  hardmute-detail/SKILL.md
  hardmute-trace/SKILL.md
  hardmute-think/SKILL.md

ultimate-skills/      ← Ultimate version
  hardmute/SKILL.md
  hardmute-info/SKILL.md
  hardmute-detail/SKILL.md
  hardmute-trace/SKILL.md
  hardmute-think/SKILL.md
```

---

## 11. Install

### Mac / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/rawp-id/hardmute/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/rawp-id/hardmute/main/install.ps1 | iex
```

Installer flow: **Skill Version → Agents → Skills → Install**

---

## 12. Compatibility

| Platform | Status |
|----------|--------|
| Claude Code | ✓ |
| Cursor | ✓ |
| Windsurf | ✓ |
| OpenAI Codex | ✓ |
| Gemini CLI | ✓ |
| Any markdown-skill agent | ✓ |

---

## 13. Proven Impact

- output ↓ **~97%**
- token budget shifts entirely to reasoning + code
- context window pressure significantly reduced

---

## 14. Constraints

Not suitable for:

- long-form education
- explicit reasoning to user
- beginner onboarding

---

## Positioning

> **hardmute is a lightweight execution layer that removes AI noise and delivers only signal.**
