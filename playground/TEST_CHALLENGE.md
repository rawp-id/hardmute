# Noisecut Skill Test Suite 🚀

Gunakan file di folder `playground/` untuk menguji kemampuan mode **Noisecut**.

## Challenge 1: `/noisecut` (Silent Execution)
**Goal:** Ubah `noisy_app.py` menjadi file yang bersih (sesuai Code Style Noisecut) tanpa narasi sama sekali.
**Prompt:** 
> /noisecut bersihkan playground/noisy_app.py dari semua noise (comments, docstrings, extra blank lines).

**Expected Output:**
```text
✓[playground/noisy_app.py]
```
*(Dan file berubah menjadi minified version)*

---

## Challenge 2: `/noisecut-info` (Contextual Execution)
**Goal:** Tambahkan fungsi `subtract(a, b)` ke `noisy_app.py`.
**Prompt:**
> /noisecut-info tambahkan fungsi subtract(a, b) ke playground/noisy_app.py.

**Expected Output:**
```text
added: subtract function
✓[playground/noisy_app.py]
```

---

## Challenge 3: `/noisecut-detail` (Usage Instruction)
**Goal:** Buat script baru `playground/utils.py` yang berisi fungsi `get_os()` dan tunjukkan cara menjalankannya.
**Prompt:**
> /noisecut-detail buat playground/utils.py dengan fungsi get_os() yang return os.name.

**Expected Output:**
```text
file: playground/utils.py
run: python3 -c "import playground.utils; print(playground.utils.get_os())"
out: posix (atau nt)
✓[playground/utils.py]
```

---

## Challenge 4: `/noisecut-trace` (Debug Mode)
**Goal:** Coba jalankan perintah yang sengaja salah (misal: hapus file yang tidak ada).
**Prompt:**
> /noisecut-trace hapus file playground/non_existent.txt.

**Expected Output:**
```text
rm playground/non_existent.txt → fail
err: No such file or directory
fix: check file existence first
```

---

## Benchmark Success Criteria
1. **Zero Narration:** Tidak ada kata-kata seperti "Tentu, saya akan...", "Berikut hasilnya...", dsb.
2. **Tool Invocation:** AI *harus* memanggil tool (write_file/run_command) secara eksplisit.
3. **Correct Format:** Output mengikuti template yang didefinisikan di masing-masing `SKILL.md`.
