#!/usr/bin/env python3
"""Kiểm tra giải thích của 1 đề: đủ 200 câu, JSON hợp lệ, chữ cái nêu ĐẦU TIÊN khớp đáp án đúng,
độ dài hợp lý.   python3 tool/ets/check_explanations.py <test>"""
import glob, json, os, re, sys

t = int(sys.argv[1])
W = os.path.join(os.path.dirname(__file__), '..', '..', 'content', 'raw', 'ets2026')
key = json.load(open(os.path.join(W, 'keys.json')))[str(t)]
d = {}
for f in sorted(glob.glob(os.path.join(W, 'explanations', f'test{t:02d}*.json'))):
    d.update(json.load(open(f)))
problems = []
missing = [n for n in range(1, 201) if not d.get(str(n), '').strip()]
if missing:
    problems.append(f'thiếu {len(missing)} câu: {missing}')
for n, e in sorted(d.items(), key=lambda x: int(x[0])):
    letters = re.findall(r'\(([A-D])\)', e)
    if not letters:
        problems.append(f'câu {n}: không nêu đáp án dạng (X)')
    elif letters[0] != key[n]:
        problems.append(f'câu {n}: nêu ({letters[0]}) đầu tiên nhưng đáp án đúng là ({key[n]})')
    if len(e) > 420:
        problems.append(f'câu {n}: quá dài ({len(e)} ký tự)')
print(f'Test {t}: {len(d)} giải thích, {len(problems)} vấn đề')
for p in problems:
    print('  ✗', p)
sys.exit(1 if problems else 0)
