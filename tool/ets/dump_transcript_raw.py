#!/usr/bin/env python3
"""In OCR thô phần Part 3–4 trong TRANSCRIPT.pdf của 1 đề (theo thứ tự đọc 2 cột), bỏ dòng chữ Hàn.
Dùng để dựng lại transcript sạch.   python3 tool/ets/dump_transcript_raw.py <test>"""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
import build_ets as b

t = int(sys.argv[1])
lines = [l for l in b.load_tsv('tr.tsv', b.transcript_pages(t), keep_numbers=True) if not b.HANGUL.search(l.text)]
start = next((i for i, l in enumerate(lines) if b.GROUP_HEAD.match(l.text) and l.text.startswith('32')), 0)
page = None
for l in lines[start:]:
    if l.page != page:
        page = l.page
        print(f'\n--- trang {page} ---')
    print(l.text)
