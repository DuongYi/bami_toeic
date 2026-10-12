#!/usr/bin/env python3
"""Tạo khung đề theo blueprint: <dir>/meta.json + <dir>/parts/pN.json (giá trị TODO để điền).

  python3 new_test.py content/tests/bami_full_03 --blueprint full --title "Bami Full Test 03"
"""
import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from _common import blueprint_groups, save  # noqa: E402

TODO = 'TODO'


def question(part, n):
    q = {'number': n, 'answer': TODO}
    if part in (3, 4, 5, 7):
        q['content'] = TODO
    if part >= 3:
        q['options'] = [TODO] * 4
    q['explanation'] = TODO
    q['tags'] = []
    return q


def group(part, nums, flags):
    g = {'part': part}
    if part <= 4:
        g['audio'] = f'p{part}_q{nums[0]}.m4a' if len(nums) == 1 else f'p{part}_q{nums[0]}-{nums[-1]}.m4a'
        g['transcript'] = TODO
    if part == 1:
        g['image'] = f'p1_q{nums[0]}.png'
        g['transcript'] = '(A) TODO\n(B) TODO\n(C) TODO\n(D) TODO'
    if part == 2:
        g['transcript'] = 'TODO question\n(A) TODO\n(B) TODO\n(C) TODO'
    if flags.get('graphic'):
        g['image'] = f'p{part}_q{nums[0]}-{nums[-1]}_graphic.png'
    if part in (6, 7):
        g['passage'] = TODO
    g['questions'] = [question(part, n) for n in nums]
    return g


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dir')
    ap.add_argument('--blueprint', required=True)
    ap.add_argument('--title', required=True)
    ap.add_argument('--source', default='Bami TOEIC')
    ap.add_argument('--description', default='TODO')
    ap.add_argument('--free', action='store_true', help='đề miễn phí (mặc định: đề PRO)')
    ap.add_argument('--minutes', type=int, help='thời gian thi riêng (vd. quick15: 15)')
    ap.add_argument('--force', action='store_true', help='ghi đè khung đã có')
    a = ap.parse_args()

    d = Path(a.dir)
    if (d / 'parts').exists() and not a.force:
        sys.exit(f'{d}/parts đã tồn tại – dùng --force để ghi đè')
    (d / 'parts').mkdir(parents=True, exist_ok=True)
    meta = {'title': a.title, 'source': a.source, 'description': a.description, 'is_free': a.free,
            'blueprint': a.blueprint}
    minutes = a.minutes or (15 if a.blueprint == 'quick15' else None)
    if minutes:
        meta['time_limit_minutes'] = minutes
    save(d / 'meta.json', meta)
    by_part = {}
    for part, nums, flags in blueprint_groups(a.blueprint):
        by_part.setdefault(part, []).append(group(part, nums, flags))
    for part, groups in by_part.items():
        save(d / 'parts' / f'p{part}.json', groups)
        n = sum(len(g['questions']) for g in groups)
        print(f'  parts/p{part}.json  {len(groups)} nhóm · {n} câu')
    print(f'✅ Khung "{a.title}" ({a.blueprint}) tại {d}. Điền hết TODO rồi chạy assemble_test.py.')


if __name__ == '__main__':
    main()
