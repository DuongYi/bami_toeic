#!/usr/bin/env python3
"""Đáp án ETS 2024 → content/raw/ets2024/keys.json {test: {câu: chữ}}.

Bảng đáp án là ảnh nền xám, OCR cả trang sót nhiều → OCR từng ô đề (tool/pdf_tool.swift ocrrect) ở 2 độ phân giải,
gộp lại. Mỗi trang 4 ô: trái-trên, phải-trên, trái-dưới, phải-dưới (trang 2: Test 1–4, trang 3: 5–8, trang 4: 9–10).
LC câu 1–100 (ĐÁP ÁN ETS 2024 LC.pdf), RC câu 101–200 (… RC.pdf). In câu thiếu / mâu thuẫn để soát tay;
sửa tay ghi vào content/raw/ets2024/keys_fix.json {test: {câu: chữ}} rồi chạy lại.

  python3 tool/ets2024/extract_keys.py
"""
import json
import os
import re
import subprocess
from collections import defaultdict

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
WORK = os.path.join(ROOT, 'content', 'raw', 'ets2024')
PDF = {'lc': os.path.join(ROOT, 'content', 'ETS2024', 'ĐÁP ÁN ETS 2024 LC.pdf'),
       'rc': os.path.join(ROOT, 'content', 'ETS2024', 'ĐÁP ÁN ETS 2024 RC.pdf')}
BOXES = [(0.06, 0.12), (0.50, 0.12), (0.06, 0.55), (0.50, 0.55)]  # x, y góc trên-trái; rộng 0.40, cao 0.37
FIX = str.maketrans({'А': 'A', 'В': 'B', 'С': 'C', 'Д': 'D', 'О': 'D', '0': 'D', 'Ο': 'D'})
PAIR = re.compile(r'(\d{1,3})\s*\(?\s*([ABCDАВСО0])\s*\)')


def ocr_box(pdf, page, x, y, dpi, w=0.40):
    out = subprocess.run(
        ['swift', os.path.join(ROOT, 'tool', 'pdf_tool.swift'), 'ocrrect', pdf, str(page), str(x), str(y), str(w), '0.37',
         str(dpi)], capture_output=True, text=True).stdout
    return out


def main():
    votes = defaultdict(lambda: defaultdict(list))  # test → câu → [chữ…]
    for part, pdf in PDF.items():
        lo, hi = (1, 100) if part == 'lc' else (101, 200)
        for test in range(1, 11):
            page = 2 + (test - 1) // 4
            x, y = BOXES[(test - 1) % 4]
            for dpi in (450, 600):
                for n, letter in PAIR.findall(ocr_box(pdf, page, x, y, dpi)):
                    n = int(n)
                    if lo <= n <= hi:
                        votes[test][n].append(letter.translate(FIX))
            # Lượt bổ sung khung rộng hơn (cột ngoài cùng hay bị cắt) – chỉ điền câu còn thiếu.
            if any(n not in votes[test] for n in range(lo, hi + 1)):
                for n, letter in PAIR.findall(ocr_box(pdf, page, x - 0.03, y, 500, w=0.46)):
                    n = int(n)
                    if lo <= n <= hi and n not in votes[test]:
                        votes[test][n].append(letter.translate(FIX))
    fix_path = os.path.join(WORK, 'keys_fix.json')
    manual = json.load(open(fix_path)) if os.path.exists(fix_path) else {}
    keys, report = {}, []
    for test in range(1, 11):
        k = {}
        for n in range(1, 201):
            v = votes[test].get(n, [])
            if str(n) in manual.get(str(test), {}):
                k[str(n)] = manual[str(test)][str(n)]
            elif v:
                best = max(set(v), key=v.count)
                k[str(n)] = best
                if len(set(v)) > 1:
                    report.append(f'Test {test} câu {n}: OCR không khớp {v} → lấy {best}')
        missing = [n for n in range(1, 201) if str(n) not in k]
        print(f'Test {test}: {len(k)}/200' + (f' · thiếu {missing}' if missing else ''))
        keys[str(test)] = k
    for r in report:
        print('  !', r)
    json.dump(keys, open(os.path.join(WORK, 'keys.json'), 'w'), indent=1, sort_keys=True)


if __name__ == '__main__':
    main()
