# hardmute Skill Test Suite 🚀

Gunakan file di folder `playground/` untuk menguji kemampuan mode **hardmute**.

## Challenge 1: `/hardmute` (Silent Execution)

**Goal:** Ubah `noisy_app.py` menjadi file yang bersih (sesuai Code Style hardmute) tanpa narasi sama sekali.
**Prompt:**

> /hardmute bersihkan playground/noisy_app.py dari semua noise (comments, docstrings, extra blank lines).

**Expected Output:**

```text
✓[playground/noisy_app.py]
```

_(Dan file berubah menjadi minified version)_

---

## Challenge 2: `/hardmute-info` (Contextual Execution)

**Goal:** Tambahkan fungsi `subtract(a, b)` ke `noisy_app.py`.
**Prompt:**

> /hardmute-info tambahkan fungsi subtract(a, b) ke playground/noisy_app.py.

**Expected Output:**

```text
added: subtract function
✓[playground/noisy_app.py]
```

---

## Challenge 3: `/hardmute-detail` (Usage Instruction)

**Goal:** Buat script baru `playground/utils.py` yang berisi fungsi `get_os()` dan tunjukkan cara menjalankannya.
**Prompt:**

> /hardmute-detail buat playground/utils.py dengan fungsi get_os() yang return os.name.

**Expected Output:**

```text
file: playground/utils.py
run: python3 -c "import playground.utils; print(playground.utils.get_os())"
out: posix (atau nt)
✓[playground/utils.py]
```

---

## Challenge 4: `/hardmute-trace` (Debug Mode)

**Goal:** Coba jalankan perintah yang sengaja salah (misal: hapus file yang tidak ada).
**Prompt:**

> /hardmute-trace hapus file playground/non_existent.txt.

**Expected Output:**

```text
rm playground/non_existent.txt → fail
err: No such file or directory
fix: check file existence first
```

---

## Benchmark Success Criteria

1. **Zero Narration:** Tidak ada kata-kata seperti "Tentu, saya akan...", "Berikut hasilnya...", dsb.
2. **Tool Invocation:** AI _harus_ memanggil tool (write_file/run_command) secara eksplisit.
3. **Correct Format:** Output mengikuti template yang didefinisikan di masing-masing `SKILL.md`.
