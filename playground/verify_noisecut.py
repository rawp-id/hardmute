import os
import re

def check_noise(filepath):
    """Checks if a file still contains noise according to hardmute standards."""
    if not os.path.exists(filepath):
        print(f"✗ File {filepath} not found.")
        return

    with open(filepath, 'r') as f:
        content = f.read()
        lines = content.splitlines()

    issues = []

    # 1. Check for docstrings
    if '"""' in content or "'''" in content:
        issues.append("Docstrings found (✗)")

    # 2. Check for verbose comments (more than 3 words)
    comment_pattern = re.compile(r'#\s*(.*)')
    for i, line in enumerate(lines):
        match = comment_pattern.search(line)
        if match:
            comment_text = match.group(1).strip()
            if len(comment_text.split()) > 3:
                issues.append(f"Verbose comment on line {i+1}: '{comment_text}' (✗)")

    # 3. Check for consecutive blank lines
    consecutive_blanks = 0
    for i, line in enumerate(lines):
        if line.strip() == "":
            consecutive_blanks += 1
            if consecutive_blanks > 1:
                issues.append(f"Consecutive blank lines at line {i+1} (✗)")
                break
        else:
            consecutive_blanks = 0

    if not issues:
        print(f"✓ {filepath} is clean signal!")
    else:
        print(f"✗ {filepath} has noise:")
        for issue in issues:
            print(f"  - {issue}")

if __name__ == "__main__":
    print("--- hardmute Verifier ---")
    check_noise("playground/noisy_app.py")
