#!/usr/bin/env python3
"""Soát chất lượng đề đã dựng: file media, số đáp án, chỗ trống Part 5, từ OCR lỗi (bỏ qua tên riêng).

    python3 tool/ets/audit.py 1-10
"""
import json, os, re, sys

WORDS = set(w.lower() for w in open('/usr/share/dict/words').read().split())
SUFFIX = ['s', 'es', 'ed', 'd', 'ing', 'ly', 'er', 'ers', 'est', 'al', 'ment', 'ments', 'ness', 'ion', 'ions']


def known(w):
    if w in WORDS:
        return True
    for suf in SUFFIX:
        if w.endswith(suf):
            base = w[:-len(suf)]
            if base in WORDS or base + 'e' in WORDS or (base.endswith('i') and base[:-1] + 'y' in WORDS):
                return True
            if len(base) > 2 and base[-1] == base[-2] and base[:-1] in WORDS:  # planned → plan
                return True
    return False


def audit(t):
    folder = os.path.join(os.path.dirname(__file__), '..', '..', 'content', 'tests', f'ets2026_test{t:02d}')
    d = json.load(open(os.path.join(folder, 'test.json')))
    out = []
    for g in d['groups']:
        for k in ('audio', 'image'):
            if g.get(k) and not os.path.exists(os.path.join(folder, g[k])):
                out.append(f'thiếu file {g[k]}')
        for q in g['questions']:
            n, p = q['number'], g['part']
            if p == 5 and '-------' not in (q.get('content') or ''):
                out.append(f'câu {n}: Part 5 mất chỗ trống → {q.get("content", "")[:70]}')
            if p >= 3 and p != 6 and not q.get('content'):
                out.append(f'câu {n}: thiếu câu hỏi')
            if p >= 3 and len(q.get('options', [])) != 4:
                out.append(f'câu {n}: {len(q.get("options", []))} đáp án')
            text = ' '.join([q.get('content') or ''] + q.get('options', []))
            lower = re.findall(r'(?<![A-Za-z])[a-z]{4,}(?![A-Za-z])', text)  # bỏ qua tên riêng viết hoa
            bad = [w for w in lower if not known(w)]
            if len(bad) >= 2 or (lower and len(bad) / len(lower) > 0.3 and bad):
                out.append(f'câu {n}: nghi OCR lỗi {bad[:5]}')
    return out


if __name__ == '__main__':
    a, _, b = (sys.argv[1] if len(sys.argv) > 1 else '1-10').partition('-')
    total = 0
    for t in range(int(a), int(b or a) + 1):
        issues = audit(t)
        total += len(issues)
        for i in issues:
            print(f'T{t} {i}')
    print(f'Tổng: {total}')
