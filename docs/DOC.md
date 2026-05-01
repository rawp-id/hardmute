# **Noisecut**

**Tagline:** *execution without noise*

---

## 1. 🎯 Overview

**Noisecut** adalah layer kontrol output untuk AI/agent yang:

* menghilangkan “noise” (penjelasan tidak perlu)
* memprioritaskan eksekusi
* mengurangi token usage secara signifikan

> **AI that executes, not explains.**

---

## 2. 🧠 Problem

LLM boros karena:

* narration
* repetition
* verbose explanation

Dampak:

* biaya tinggi
* latency naik
* context cepat penuh

---

## 3. 💡 Solution

Noisecut = **execution-first protocol**

```text
input → execute → minimal output
```

---

## 4. 🧩 Core Concept

Visual = **pulse dipotong garis**

Makna:

* pulse = output / signal
* cut = remove noise

👉 hasil:

> **clean signal only**

---

## 5. ⚙️ Modes (Noisecut Family)

### 🔹 `/noisecut` (level 0)

* silent execution
* output minimal

```text
✓
```

atau

```text
✗ perm
```

---

### 🔹 `/noisecut-info`

* hasil + konteks minimum
* max 2 baris

```text
file: index.php
ok
```

---

### 🔹 `/noisecut-detail`

* hasil + cara pakai
* max 5 baris

```text
file: index.php
run: php index.php
out: Hello World
```

---

### 🔹 `/noisecut-trace`

* debug summary
* no verbose reasoning

```text
write_file → fail
perm denied
fix chmod
```

---

## 6. 🧠 Design Principles

1. **Execution > explanation**
2. **Signal > noise**
3. **Deterministic output**
4. **Minimal tokens**
5. **Composable modes**

---

## 7. 🔁 Flow

```text
task
→ noisecut execute
→ success → ✓
→ fail → noisecut-trace
```

---

## 8. 📊 Proven Impact

Dari eksperimen:

* output ↓ **97.5%**
* total token ↓ signifikan
* model calls ↓

👉 bukan cuma style, tapi:

> **system efficiency improvement**

---

## 9. 🧬 Architecture

```text
/core(brain/skills - opsional)
/noisecut/skill.md
/noisecut-info/skill.md
/noisecut-detail/skill.md
/noisecut-trace/skill.md
```

---

## 10. 🎨 Brand & Identity

### Logo

* rounded pulse line
* 1 diagonal cut line
* tanpa text (icon-first)

### Makna

> signal dipotong noise

---

### Visual Rules

* minimal
* rounded (friendly)
* 1 accent color (cut)
* scalable (favicon ready)

---

## 11. 🔌 Compatibility

* OpenAI
* Anthropic
* VS Code
* Cursor

---

## 12. ⚠️ Constraints

Tidak cocok untuk:

* edukasi panjang
* reasoning eksplisit
* onboarding beginner

---

## 13. 🚀 Future

* auto mode switching
* context compression engine
* agent-native integration
* SDK

---

## 14. 🏁 Success Criteria

* token ↓ drastis
* output konsisten
* debugging tetap possible
* user ga perlu re-ask

---

## 🔚 Positioning final

> **Noisecut is a lightweight execution layer that removes AI noise and delivers only signal.**

