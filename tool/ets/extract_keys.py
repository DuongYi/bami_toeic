#!/usr/bin/env python3
"""Trích bảng đáp án ETS (mỗi trang 4 bảng 2×2, trang cuối 2 bảng) bằng OCR vùng.

    python3 tool/ets/extract_keys.py <file.pdf> <trang> <test bắt đầu> [số bảng=4] > keys.json
In JSON {test: {câu: "A"}}; báo ra stderr các câu thiếu để soát tay.
"""
import json, re, subprocess, sys

PDF, PAGE, FIRST = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
COUNT = int(sys.argv[4]) if len(sys.argv) > 4 else 4
# (x, y, w, h) tỉ lệ trang của 4 bảng: trên-trái, trên-phải, dưới-trái, dưới-phải
BOXES = [(0.10, 0.11, 0.38, 0.37), (0.51, 0.11, 0.38, 0.37),
         (0.10, 0.55, 0.38, 0.37), (0.51, 0.55, 0.38, 0.37)]
PAIR = re.compile(r'(\d{1,3})\s*\(?\s*([ABCD])\s*\)?')

out = {}
for k in range(COUNT):
    x, y, w, h = BOXES[k]
    res = subprocess.run(['swift', 'tool/pdf_tool.swift', 'ocrrect', PDF, str(PAGE), *map(str, (x, y, w, h)), '450'],
                         capture_output=True, text=True, check=True).stdout
    keys = {}
    for line in res.splitlines():
        text = line.split('\t', 2)[-1]
        for n, a in PAIR.findall(text):
            keys.setdefault(int(n), a)
    test = FIRST + k
    nums = sorted(n for n in keys if 1 <= n <= 200)
    lo = 1 if nums and nums[0] <= 100 else 101
    missing = [n for n in range(lo, lo + 100) if n not in keys]
    print(f'Test {test}: {len(nums)} đáp án, thiếu {missing}', file=sys.stderr)
    out[test] = {n: keys[n] for n in nums}
json.dump(out, sys.stdout, indent=1)
