#!/usr/bin/env python3
"""Đối chiếu transcript Part 1–2 với giải thích: câu tiếng Anh được trích trong giải thích câu n
phải xuất hiện trong transcript câu n. Phát hiện transcript gắn lệch số câu.

    python3 tool/ets/check_transcripts.py [nguồn: built|parser] 1-10
"""
import glob, json, os, re, sys
sys.path.insert(0, os.path.dirname(__file__))

W = os.path.join(os.path.dirname(__file__), '..', '..', 'content')
norm = lambda s: re.sub(r'[^a-z0-9 ]', '', re.sub(r'\s+', ' ', s.lower().replace('’', "'"))).strip()


def explanations(t):
    d = {}
    for f in glob.glob(os.path.join(W, 'raw', 'ets2026', 'explanations', f'test{t:02d}*.json')):
        d.update(json.load(open(f)))
    return d


def transcripts(t, source):
    if source == 'parser':
        import build_ets as b
        p1p2, _ = b.parse_transcript(t)
        return {n: stem + ' ' + ' '.join(o) for n, (stem, o) in p1p2.items()}
    d = json.load(open(os.path.join(W, 'tests', f'ets2026_test{t:02d}', 'test.json')))
    return {g['questions'][0]['number']: g.get('transcript', '') for g in d['groups'] if g['part'] <= 2}


source = sys.argv[1] if len(sys.argv) > 2 else 'built'
a, _, b2 = sys.argv[-1].partition('-')
for t in range(int(a), int(b2 or a) + 1):
    ex, tr = explanations(t), transcripts(t, source)
    ok, bad, missing = 0, [], []
    for n in range(1, 32):
        # ghép cặp nháy tuần tự rồi mới lọc: chỉ lấy câu trích tiếng Anh (ASCII), đủ dài
        raw = re.findall(r"'([^']+)'", ex.get(str(n), '').replace("’", "'"))
        quotes = [norm(q) for q in raw if all(ord(c) < 128 for c in q) and len(q) >= 8]
        if not quotes:
            continue
        text = norm(tr.get(n, ''))
        if not text:
            missing.append(n)
        elif any(q[:25] in text for q in quotes):
            ok += 1
        else:
            bad.append(n)
    print(f'T{t} [{source}]: khớp {ok}, lệch {len(bad)} {bad}, thiếu {missing}')
