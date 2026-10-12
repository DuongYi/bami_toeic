#!/usr/bin/env python3
"""Chuẩn hoá đề về đúng kiểu ETS + cân bằng bảng đáp án. Chạy lại an toàn.

  python3 normalize_test.py content/tests/<id> [--seed 7] [--dry-run] [--no-shuffle]

1. Part 1/2: gỡ `content` / `options` (app sẽ in ra màn hình → lộ đáp án); nếu transcript chưa có câu (A)–(D)
   thì dựng lại từ content + options trước khi gỡ. Transcript chuẩn hoá mỗi phương án 1 dòng.
2. Part 6: gỡ `content` (gợi ý kiểu "Choose the best preposition…"); chỗ trống "[131] -------" → "---(131)---".
   Tags: bỏ tag ngoài danh sách chuẩn; câu không còn tag hợp lệ thì tự gắn bằng tool/ets/tagging.py.
3. Xáo phương án để đáp án trải đều A–D (Part 2: A–C), không quá 3 câu liên tiếp cùng chữ.
   Đổi theo: `options`, `answer`, mọi "(X)" trong `explanation`, thứ tự câu (A)–(D) trong transcript Part 1/2.
   Bỏ qua câu `fixed_order: true`, câu chèn [1]–[4] và câu có phương án là số / giờ / ngày (giữ thứ tự tăng dần).
Sau khi chạy: audio Part 1/2 phải tạo lại (build_audio.py tự nhận ra nhờ manifest).
"""
import argparse
import random
import re
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from _common import (LETTER_REF, LETTERS, TAGS, join_listening_transcript, letters_for, load,  # noqa: E402
                     questions, save, split_listening_transcript, test_dir)


def _auto_tagger():
    """tag_question() của tool/ets/tagging.py (tìm repo từ thư mục hiện tại)."""
    for root in [Path.cwd(), *Path.cwd().parents]:
        if (root / 'tool/ets/tagging.py').exists():
            sys.path.insert(0, str(root / 'tool/ets'))
            from tagging import tag_question  # noqa: E402
            return tag_question
    return None


def retag(g, q, tagger):
    tags = [t for t in (q.get('tags') or []) if t in TAGS]
    if not tags and tagger:
        first = (g.get('transcript') or '').splitlines()[0] if g.get('transcript') else None
        tags = [t for t in tagger(g['part'], q.get('content'), q.get('options'), g.get('passage'), first) if t in TAGS]
    if g['part'] == 7 and q['number'] >= 176 and 'multi-passage' not in tags:
        tags.append('multi-passage')
    changed = tags != (q.get('tags') or [])
    q['tags'] = tags
    return changed

_ORDERED = re.compile(
    r'^\s*(\[\d\]|[$€£]?\s?\d[\d,.:]*\s*(%|a\.m\.|p\.m\.|A\.M\.|P\.M\.)?.*|'
    r'(on |in |at |by )?(monday|tuesday|wednesday|thursday|friday|saturday|sunday|january|february|march|april|may|june|'
    r'july|august|september|october|november|december)\b.*)$',
    re.I,
)


def is_fixed(part, q):
    if q.get('fixed_order'):
        return True
    opts = q.get('options') or []
    if part <= 2:
        return False
    return len(opts) >= 2 and all(_ORDERED.match(o or '') for o in opts)


def strip_listening(g, q, log):
    """Part 1/2 không được có content/options."""
    head, opts = split_listening_transcript(g.get('transcript'))
    if q.get('options'):
        if len(opts) < len(q['options']):
            opts = {LETTERS[i]: o for i, o in enumerate(q['options'])}
            if g['part'] == 2 and not head:
                head = q.get('content') or ''
        log.append(f"câu {q['number']}: gỡ content/options Part {g['part']}")
    q.pop('options', None)
    q.pop('content', None)
    if opts:
        g['transcript'] = join_listening_transcript(head, opts)


def target_sequence(items, rng):
    """items: [(Part, số câu, bộ chữ, cố định?, đáp án hiện tại)] → {số câu: chữ đích}, cân bằng trong từng Part."""
    targets, used = {}, Counter()
    for part in sorted({it[0] for it in items}):
        chunk = _balance([it[1:] for it in items if it[0] == part], rng, used)
        targets.update(chunk)
        used.update(chunk.values())
    return targets


def _balance(items, rng, used):
    targets = {}
    for letters in ('ABCD', 'ABC'):
        movable = [n for n, ls, fixed, _ in items if ls == letters and not fixed]
        fixed_count = Counter(a for _, ls, fixed, a in items if ls == letters and fixed)
        total = len(movable) + sum(fixed_count.values())
        if not movable:
            continue
        # Mỗi chữ ~ total/len(letters), trừ phần câu cố định đã chiếm.
        want = {c: total // len(letters) for c in letters}
        # Phần dư dồn cho chữ đang ít nhất trên cả đề (đề ngắn vẫn cân), hoà thì chọn ngẫu nhiên.
        spare = sorted(letters, key=lambda c: (used[c], rng.random()))
        for c in spare[: total % len(letters)]:
            want[c] += 1
        pool = []
        for c in letters:
            pool += [c] * max(0, want[c] - fixed_count[c])
        while len(pool) < len(movable):
            pool.append(rng.choice(letters))
        rng.shuffle(pool)
        for n, c in zip(movable, pool[: len(movable)]):
            targets[n] = c
    return targets


def fix_runs(items, targets, rng, limit=3):
    """Đổi chỗ để không có > limit câu liên tiếp cùng chữ."""
    order = [n for _, n, *_ in items]
    answer = {n: targets.get(n, a) for _, n, _, _, a in items}
    part_of = {n: p for p, n, *_ in items}
    movable = {n: ls for _, n, ls, fixed, _ in items if not fixed}
    for _ in range(200):
        bad = None
        for i in range(limit, len(order)):
            if len({answer[order[j]] for j in range(i - limit, i + 1)}) == 1 and order[i] in movable:
                bad = order[i]
                break
        if bad is None:
            break
        # Đổi với câu cùng Part để giữ cân bằng từng Part.
        cands = [n for n in movable if movable[n] == movable[bad] and part_of[n] == part_of[bad]
                 and answer[n] != answer[bad]]
        if not cands:
            break
        other = rng.choice(cands)
        answer[bad], answer[other] = answer[other], answer[bad]
    return {n: answer[n] for n in movable}


def apply(g, q, new_letter, rng):
    """Đưa đáp án đúng về new_letter, xáo distractor. Trả về map chữ cũ → chữ mới."""
    part = g['part']
    letters = letters_for(part, q)
    old = q['answer'].upper()
    others_old = [c for c in letters if c != old]
    rng.shuffle(others_old)
    others_new = [c for c in letters if c != new_letter]
    mapping = {old: new_letter, **dict(zip(others_old, others_new))}
    if mapping == {c: c for c in letters}:
        return mapping
    if q.get('options'):
        new_opts = [None] * len(letters)
        for o, c in zip(q['options'], letters):
            new_opts[letters.index(mapping[c])] = o
        q['options'] = new_opts
    if part <= 2:
        head, opts = split_listening_transcript(g.get('transcript'))
        if set(opts) >= set(letters):
            g['transcript'] = join_listening_transcript(head, {mapping[c]: opts[c] for c in letters})
    q['answer'] = new_letter
    if q.get('explanation'):
        q['explanation'] = LETTER_REF.sub(lambda m: f'({mapping.get(m.group(1), m.group(1))})', q['explanation'])
    return mapping


def report(title, data):
    by_part = {}
    for g, q in questions(data):
        by_part.setdefault(g['part'], []).append(q['answer'].upper())
    print(title)
    for p in sorted(by_part):
        c = Counter(by_part[p])
        print(f'  Part {p}: ' + ' '.join(f'{k}={c.get(k, 0)}' for k in LETTERS[: 3 if p == 2 else 4]))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dir')
    ap.add_argument('--seed', type=int, default=None, help='mặc định: từ tên đề (ổn định)')
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-shuffle', action='store_true', help='chỉ gỡ content/options sai chỗ')
    a = ap.parse_args()

    d = test_dir(a.dir)
    data = load(d / 'test.json')
    rng = random.Random(a.seed if a.seed is not None else data.get('title', ''))
    report('Trước:', data)
    log = []

    tagger = _auto_tagger()
    retagged = 0
    for g, q in questions(data):
        if g['part'] in (1, 2):
            strip_listening(g, q, log)
        if g['part'] == 6 and g.get('passage'):
            n = q['number']
            fixed_blank = re.sub(r'\[%d\]\s*-{3,}|-{3,}\s*\[%d\]|-{3,}\s*\(%d\)(?!-)' % (n, n, n),
                                 f'---({n})---', g['passage'])
            if fixed_blank != g['passage']:
                g['passage'] = fixed_blank
                log.append(f'câu {n}: chuẩn hoá chỗ trống Part 6 thành ---({n})---')
        if g['part'] == 6 and q.get('content'):
            q.pop('content')
            log.append(f"câu {q['number']}: gỡ content Part 6")
        retagged += retag(g, q, tagger)
    if retagged:
        log.append(f'sửa tags {retagged} câu')

    invalid = [q['number'] for g, q in questions(data)
               if str(q.get('answer', '')).upper() not in letters_for(g['part'], q)]
    if invalid and not a.no_shuffle:
        sys.exit(f'Dừng: {len(invalid)} câu chưa có answer hợp lệ (vd. câu {invalid[:5]}). Điền xong rồi chạy lại.')

    if not a.no_shuffle:
        items = [(g['part'], q['number'], letters_for(g['part'], q), is_fixed(g['part'], q), q['answer'].upper())
                 for g, q in questions(data)]
        targets = fix_runs(items, target_sequence(items, rng), rng)
        moved = 0
        for g, q in questions(data):
            if q['number'] in targets:
                m = apply(g, q, targets[q['number']], rng)
                moved += any(k != v for k, v in m.items())
        fixed = sum(1 for *_, f, _ in items if f)
        log.append(f'xáo phương án {moved} câu, giữ nguyên thứ tự {fixed} câu (số/giờ/ngày/[1]–[4]/fixed_order)')

    for line in log[:15]:
        print('  •', line)
    if len(log) > 15:
        print(f'  … và {len(log) - 15} thay đổi khác')
    report('Sau:', data)
    if a.dry_run:
        print('(dry-run: không ghi file)')
        return
    save(d / 'test.json', data)
    print(f'✅ Đã ghi {d}/test.json. Tiếp: validate_test.py rồi build_audio.py (audio Part 1/2 cần tạo lại).')


if __name__ == '__main__':
    main()
