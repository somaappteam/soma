import re
import sys

file_name = sys.argv[1] if len(sys.argv) > 1 else "analyze_v5.txt"
with open(file_name, "r", encoding="utf-16le") as f:
    text = f.read()

lines = text.split("\n")
errors = []
for i, line in enumerate(lines):
    if "dm_chat_screen.dart" in line:
        context = " ".join(lines[i:i+3])
        match = re.search(r"dm_chat_screen\.dart:(\d+):(\d+)", context)
        if match:
            msg = context.replace("   ", " ").replace("  ", " ").strip()
            # truncate for quick read
            if len(msg) > 120: msg = msg[:120] + "..."
            errors.append((int(match.group(1)), f"Line {match.group(1)}: {msg}"))

for line_num, msg in sorted(list(set(errors)), key=lambda x: x[0]):
    print(msg)
