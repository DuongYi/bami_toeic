#!/usr/bin/env python3
"""Kiểm tra test.json theo chuẩn ETS + những lỗi làm lộ đáp án. Thoát mã 1 nếu có lỗi.

  python3 validate_test.py content/tests/<id> [--blueprint full|mini25|quick15|listening50|part:N] [--media]

--media: kiểm tra file audio/ảnh có thật và audio khớp transcript hiện tại (manifest của build_audio.py).
"""
import argparse
import re
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from _common import (LETTER_REF, LETTERS, SPEAKER, TAGS, blueprint_groups, letters_for, load,  # noqa: E402
                     questions, split_listening_transcript, test_dir)

errors, warnings = [], []


def err(where, msg):
    errors.append(f'{where}: {msg}')


def warn(where, msg):
    warnings.append(f'{where}: {msg}')


def todo(v):
    return isinstance(v, str) and 'TODO' in v


def check_group(gi, g):
    part = g.get('part')
    qs = g.get('questions') or []
    where = f'nhóm {gi + 1} (Part {part}, câu {qs[0]["number"] if qs else "?"})'
    if part not in range(1, 8):
        return err(where, 'part phải là 1–7')
    if not qs:
        return err(where, 'không có câu hỏi')
    for k in ('transcript', 'passage'):
        if todo(g.get(k)):
            err(where, f'{k} còn TODO')

    size = {1: (1,), 2: (1,), 3: (3,), 4: (3,), 5: (1,), 6: (4,), 7: (2, 3, 4, 5)}[part]
    if len(qs) not in size:
        err(where, f'Part {part} mỗi nhóm {"/".join(map(str, size))} câu, đang có {len(qs)}')

    if part <= 4 and not g.get('audio'):
        err(where, 'thiếu audio')
    if part <= 4 and not (g.get('transcript') or '').strip():
        err(where, 'thiếu transcript')
    if part == 1 and not g.get('image'):
        err(where, 'Part 1 thiếu ảnh')
    if part in (6, 7) and not (g.get('passage') or '').strip():
        err(where, 'thiếu passage')

    if part in (1, 2):
        head, opts = split_listening_transcript(g.get('transcript'))
        need = 'ABCD' if part == 1 else 'ABC'
        if ''.join(sorted(opts)) != need:
            err(where, f'transcript phải có đúng các câu {", ".join(f"({c})" for c in need)}')
        if part == 2 and not head:
            err(where, 'transcript Part 2 thiếu câu hỏi ở dòng đầu')
        if part == 1 and head:
            warn(where, 'transcript Part 1 chỉ nên gồm 4 câu (A)–(D)')
    if part == 3:
        lines = [l for l in (g.get('transcript') or '').splitlines() if l.strip()]
        speakers = {m.group(1) for l in lines if (m := SPEAKER.match(l))}
        if len(speakers) < 2:
            err(where, 'transcript Part 3 cần nhãn người nói M:/W: (M1:/M2:/W1:… khi 3 người) mỗi lượt 1 dòng')
        unlabeled = [l for l in lines if not SPEAKER.match(l)]
        if unlabeled:
            warn(where, f'{len(unlabeled)} dòng transcript không có nhãn người nói')
    if part == 4 and SPEAKER.match((g.get('transcript') or '').splitlines()[0] if g.get('transcript') else ''):
        warn(where, 'Part 4 là bài nói 1 người – không cần nhãn người nói')

    graphic_qs = [q for q in qs if (q.get('content') or '').lower().startswith('look at the graphic')]
    if graphic_qs and not g.get('image'):
        err(where, '"Look at the graphic" nhưng nhóm không có image')
    if part in (3, 4) and g.get('image') and not graphic_qs:
        warn(where, 'có biểu đồ nhưng không có câu "Look at the graphic."')

    if part == 6:
        passage = g.get('passage') or ''
        for q in qs:
            if not re.search(r'-+\(\s*%d\s*\)-+' % q['number'], passage):
                err(where, f'passage thiếu chỗ trống ---({q["number"]})---')
        n_ins = sum('sentence-insertion' in (q.get('tags') or []) for q in qs)
        if n_ins != 1:
            warn(where, f'đoạn Part 6 nên có đúng 1 câu chèn câu (tag sentence-insertion), đang có {n_ins}')

    for q in qs:
        check_question(g, q)
        c = q.get('content') or ''
        if part == 7 and 'positions marked' in c:
            if q.get('options') != ['[1]', '[2]', '[3]', '[4]']:
                err(f'câu {q["number"]}', 'câu chèn câu: options phải là ["[1]", "[2]", "[3]", "[4]"]')
            for i in range(1, 5):
                if f'[{i}]' not in (g.get('passage') or ''):
                    err(f'câu {q["number"]}', f'passage thiếu vị trí [{i}]')
        quoted = re.search(r'says?, "([^"]+)"|writes?, "([^"]+)"', c)
        if quoted:
            phrase = (quoted.group(1) or quoted.group(2)).strip(' .?!')
            source = (g.get('transcript') or '') + (g.get('passage') or '')
            if phrase.lower() not in source.lower():
                err(f'câu {q["number"]}', f'câu trích "{phrase}" không có nguyên văn trong transcript/passage')


def check_question(g, q):
    part = g['part']
    n = q.get('number')
    where = f'câu {n}'
    if not isinstance(n, int):
        return err(where, 'number phải là số nguyên')
    ans = str(q.get('answer', '')).upper()
    letters = letters_for(part, q)
    if ans not in letters:
        err(where, f'answer "{q.get("answer")}" phải thuộc {"/".join(letters)}')

    if part in (1, 2):
        if q.get('options'):
            err(where, f'Part {part} KHÔNG được có options (app sẽ in ra → lộ đáp án). Chạy normalize_test.py')
        if q.get('content'):
            err(where, f'Part {part} KHÔNG được có content (câu hỏi chỉ nằm trong audio). Chạy normalize_test.py')
    else:
        opts = q.get('options') or []
        if len(opts) != 4:
            err(where, f'cần 4 options, đang có {len(opts)}')
        if any(todo(o) or not str(o).strip() for o in opts):
            err(where, 'options rỗng hoặc còn TODO')
        if len({str(o).strip().lower() for o in opts}) != len(opts):
            err(where, 'options bị trùng')
    if part == 6 and q.get('content'):
        err(where, 'Part 6 không có content (gợi ý dạng câu làm lộ đáp án). Chạy normalize_test.py')
    if part in (3, 4, 7) and not (q.get('content') or '').strip():
        err(where, f'Part {part} cần content (câu hỏi)')
    if part == 5:
        c = q.get('content') or ''
        if c.count('-------') != 1:
            err(where, 'Part 5: content phải có đúng 1 chỗ trống "-------"')
    if todo(q.get('content')) or todo(q.get('answer')):
        err(where, 'còn TODO')

    expl = q.get('explanation') or ''
    if not expl.strip() or todo(expl):
        warn(where, 'thiếu giải thích')
    else:
        arrow = re.findall(r'→\s*\(([A-D])\)', expl)
        if arrow and arrow[-1] != ans:
            err(where, f'giải thích chỉ ra ({arrow[-1]}) nhưng answer là {ans}')
        if re.search(r'đáp án [A-D]\b|câu [A-D]\b|phương án [A-D]\b', expl, re.I):
            warn(where, 'giải thích nên gọi phương án bằng "(A)"… để normalize_test.py đổi chữ khi xáo')
        bad_refs = [c for c in LETTER_REF.findall(expl) if c not in letters]
        if bad_refs:
            err(where, f'giải thích nhắc ({bad_refs[0]}) nhưng câu chỉ có {letters}')
    tags = q.get('tags') or []
    unknown = [t for t in tags if t not in TAGS]
    if unknown:
        err(where, f'tag không hợp lệ: {unknown}')
    if not tags:
        warn(where, 'chưa có tags')


def check_key(data):
    seq = [(g['part'], q['number'], str(q.get('answer', '')).upper()) for g, q in questions(data)]
    four = [a for p, _, a in seq if p != 2]
    if len(four) >= 8:
        c = Counter(four)
        for k in LETTERS:
            share = c.get(k, 0) / len(four)
            if share > 0.35 or share < 0.15:
                err('bảng đáp án', f'({k}) chiếm {share:.0%} số câu 4 phương án (chuẩn ETS ~25%). Chạy normalize_test.py')
    by_part = {}
    for p, _, a in seq:
        by_part.setdefault(p, []).append(a)
    for p, ans in by_part.items():
        if len(ans) >= 5:
            k, n = Counter(ans).most_common(1)[0]
            if n / len(ans) > (0.6 if p == 2 else 0.5):
                err(f'Part {p}', f'({k}) là đáp án của {n}/{len(ans)} câu')
    run, prev = 1, None
    for _, n, a in seq:
        run = run + 1 if a == prev else 1
        prev = a
        if run == 5:  # đề thật đôi khi có 4 câu liền cùng chữ
            warn(f'câu {n}', f'5 câu liên tiếp cùng đáp án ({a})')

    longest = total = 0
    for g, q in questions(data):
        opts = q.get('options') or []
        if g['part'] in (3, 4, 7) and len(opts) == 4 and str(q.get('answer', '')).upper() in LETTERS[:4]:
            lens = [len(o) for o in opts]
            total += 1
            if lens[LETTERS.index(str(q['answer']).upper())] == max(lens) and lens.count(max(lens)) == 1:
                longest += 1
    if total >= 10 and longest / total > 0.45:
        warn('phương án', f'đáp án đúng là phương án dài nhất ở {longest}/{total} câu Part 3/4/7 – dễ đoán, viết distractor dài tương đương')


def check_order(data, blueprint):
    nums = [q.get('number') for _, q in questions(data)]
    dup = [n for n, c in Counter(nums).items() if c > 1]
    if dup:
        err('số câu', f'trùng: {dup[:10]}')
    if nums != sorted(nums):
        err('số câu', 'phải tăng dần theo thứ tự nhóm')
    parts = [g.get('part') for g in data['groups']]
    if parts != sorted(parts):
        err('thứ tự', 'các nhóm phải theo thứ tự Part 1 → 7')
    if not blueprint:
        return
    # Đoạn đơn Part 7 (147–175) trong đề thật xếp 2/3/4 câu xen kẽ → chỉ so khung tổng, không so từng nhóm.
    def shape(groups):
        out, singles = [], []
        for p, nums_ in groups:
            if p == 7 and nums_[0] < 176:
                singles += nums_
            else:
                out.append((p, nums_))
        if singles:
            out.append((7, singles))
        return sorted(out)

    want = shape([(p, nums_) for p, nums_, _ in blueprint_groups(blueprint)])
    got = shape([(g['part'], [q['number'] for q in g['questions']]) for g in data['groups']])
    if want != got:
        for i, (w, h) in enumerate(zip(want, got)):
            if w != h:
                err('blueprint', f'nhóm {i + 1}: cần Part {w[0]} câu {w[1]}, đang là Part {h[0]} câu {h[1]}')
                break
        if len(want) != len(got):
            err('blueprint', f'cần {len(want)} nhóm, đang có {len(got)}')
    for p, nums_, flags in blueprint_groups(blueprint):
        if flags.get('graphic'):
            g = next((g for g in data['groups'] if g['questions'] and g['questions'][0]['number'] == nums_[0]), None)
            if g is not None and not g.get('image'):
                warn(f'câu {nums_[0]}–{nums_[-1]}', 'nhóm này trong đề thật có biểu đồ + câu "Look at the graphic."')


def check_media(d, data):
    import hashlib
    import json
    manifest_file = d / '.audio_manifest.json'
    manifest = json.loads(manifest_file.read_text()) if manifest_file.exists() else {}
    sys.path.insert(0, str(Path(__file__).parent))
    from build_audio import script_for  # noqa: E402
    for g in data['groups']:
        for k in ('audio', 'image'):
            name = g.get(k)
            if name and not name.startswith('http') and not (d / name).exists():
                err(f'câu {g["questions"][0]["number"]}', f'không có file {k} "{name}"')
        if g['part'] <= 4 and g.get('audio') and (d / g['audio']).exists():
            h = hashlib.sha1(json.dumps(script_for(g), ensure_ascii=False).encode()).hexdigest()
            if manifest.get(g['audio']) != h:
                err(f'câu {g["questions"][0]["number"]}', f'audio "{g["audio"]}" không khớp transcript hiện tại – chạy build_audio.py')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dir')
    ap.add_argument('--blueprint')
    ap.add_argument('--media', action='store_true')
    a = ap.parse_args()
    d = test_dir(a.dir)
    data = load(d / 'test.json')
    if not isinstance(data.get('title'), str) or todo(data.get('title')):
        err('đề', 'thiếu title')
    if todo(data.get('description')):
        warn('đề', 'description còn TODO')
    for gi, g in enumerate(data.get('groups') or []):
        check_group(gi, g)
    check_order(data, a.blueprint)
    check_key(data)
    if a.media:
        check_media(d, data)

    n = sum(1 for _ in questions(data))
    print(f'{data.get("title")} · {len(data["groups"])} nhóm · {n} câu')
    for e in errors[:60]:
        print('  ❌', e)
    if len(errors) > 60:
        print(f'  … và {len(errors) - 60} lỗi khác')
    for w in warnings[:30]:
        print('  ⚠️ ', w)
    if len(warnings) > 30:
        print(f'  … và {len(warnings) - 30} cảnh báo khác')
    print(f'{"❌" if errors else "✅"} {len(errors)} lỗi · {len(warnings)} cảnh báo')
    sys.exit(1 if errors else 0)


if __name__ == '__main__':
    main()
