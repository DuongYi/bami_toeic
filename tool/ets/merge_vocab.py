#!/usr/bin/env python3
"""Gộp content/raw/ets2026/vocab/testNN.json → ets2026_all.json (bỏ trùng theo word, giữ lần đầu xuất hiện).

  python3 tool/ets/merge_vocab.py
Sau đó: dart run tool/import_vocab.dart content/raw/ets2026/vocab/ets2026_all.json
"""
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2] / 'content/raw/ets2026/vocab'
FIELDS = ['word', 'ipa', 'pos', 'meaning', 'example', 'example_meaning', 'topic', 'source']
TOPICS = {'Office', 'Finance', 'Hiring', 'Marketing', 'Sales', 'Travel', 'Purchasing',
          'Manufacturing', 'Real Estate', 'Health', 'Events', 'Technology', 'Dining',
          'Transportation', 'Customer Service', 'General'}

seen, out, problems = {}, [], []
files = sorted(ROOT.glob('test[0-9][0-9].json'))
for f in files:
    for i, v in enumerate(json.loads(f.read_text())):
        where = f'{f.name}#{i}'
        if set(v) != set(FIELDS):
            problems.append(f'{where}: trường sai {sorted(v)}')
            continue
        if not v['word'].strip() or not v['meaning'].strip():
            problems.append(f'{where}: thiếu word/meaning')
            continue
        if v['topic'] not in TOPICS:
            problems.append(f'{where}: topic lạ {v["topic"]}')
            continue
        key = v['word'].strip().lower()
        if key in seen:
            seen[key]['_dups'].append(v['source'])
            continue
        item = {k: (v[k].strip() if isinstance(v[k], str) else v[k]) for k in FIELDS}
        item['_dups'] = []
        seen[key] = item
        out.append(item)

dups = sum(len(v['_dups']) for v in out)
for v in out:
    del v['_dups']
(ROOT / 'ets2026_all.json').write_text(json.dumps(out, ensure_ascii=False, indent=1))
print(f'{len(files)} file → {len(out)} từ (bỏ {dups} từ trùng) → {ROOT / "ets2026_all.json"}')
for p in problems:
    print('  ⚠️', p)
sys.exit(1 if problems else 0)
