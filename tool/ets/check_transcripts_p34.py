#!/usr/bin/env python3
"""Kiểm tra transcript Part 3–4 dựng lại: đủ 23 nhóm (32,35,…,98), không rỗng, không chữ Hàn/ký tự rác,
Part 3 có nhãn người nói.   python3 tool/ets/check_transcripts_p34.py <test>"""
import json, os, re, sys
t = int(sys.argv[1])
p = os.path.join(os.path.dirname(__file__), '..', '..', 'content', 'raw', 'ets2026', 'transcripts', f'test{t:02d}.json')
d = json.load(open(p))
problems = []
for a in range(32, 99, 3):
    tr = d.get(str(a), '')
    if len(tr) < 250:
        problems.append(f'nhóm {a}: thiếu hoặc quá ngắn ({len(tr)} ký tự)')
    if re.search(r'[\uac00-\ud7a3#*|=≥→÷{}]', tr):
        problems.append(f'nhóm {a}: còn ký tự lạ/chữ Hàn')
    if a < 71 and not re.search(r'^(W|M|W1|W2|M1|M2):', tr, re.M):
        problems.append(f'nhóm {a}: Part 3 thiếu nhãn người nói (W:/M:)')
extra = [k for k in d if k not in {str(a) for a in range(32, 99, 3)}]
if extra:
    problems.append(f'khoá thừa: {extra}')
print(f'Test {t}: {len(d)} nhóm, {len(problems)} vấn đề')
for x in problems:
    print('  ✗', x)
sys.exit(1 if problems else 0)
