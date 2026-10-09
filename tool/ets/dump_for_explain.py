#!/usr/bin/env python3
"""In nội dung 1 đề dạng gọn (để viết giải thích): transcript/đoạn văn + câu hỏi + đáp án đúng.

    python3 tool/ets/dump_for_explain.py <test> [part_from] [part_to]
"""
import json, os, sys

t = int(sys.argv[1])
lo, hi = int(sys.argv[2]) if len(sys.argv) > 2 else 1, int(sys.argv[3]) if len(sys.argv) > 3 else 7
root = os.path.join(os.path.dirname(__file__), '..', '..', 'content', 'tests', f'ets2026_test{t:02d}', 'test.json')
for g in json.load(open(root))['groups']:
    if not lo <= g['part'] <= hi:
        continue
    nums = [q['number'] for q in g['questions']]
    print(f"\n### P{g['part']} · câu {nums[0]}{'-' + str(nums[-1]) if len(nums) > 1 else ''}")
    for k in ('transcript', 'passage'):
        if g.get(k):
            print(f'[{k}] ' + g[k].replace('\n', ' / '))
    for q in g['questions']:
        opts = ' | '.join(f'{chr(65 + i)}) {o}' for i, o in enumerate(q.get('options', [])))
        print(f"{q['number']}. {q.get('content') or ''} {opts}  ✔{q['answer']}")
