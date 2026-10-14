#!/usr/bin/env python3
"""Chuyển bộ sách ETS 2024 (YBM 기출문제집 4, PDF + audio) thành đề theo định dạng tool/import_test.dart.

Dùng lại bộ tách câu / cắt ảnh của tool/ets/build_ets.py (ETS 2026), chỉ đổi nguồn và bố cục:
  content/ETS2024/FULL TEST  LC.pdf   13 trang / đề: bìa, Part 1 (trang 2–5, ảnh câu 1–6 ở trang 3–5),
                                      Part 2 (trang 6), Part 3 (7–10), Part 4 (11–13)
  content/ETS2024/FULL TEST RC.pdf    29 trang / đề: bìa, Part 5, Part 6, Part 7
  content/ETS2024/**/Test_NN-<câu>.mp3 audio cắt theo câu (Part 1/2) / nhóm (Part 3/4: Test_NN-32-34.mp3)
  content/raw/ets2024/{lc,rc300}.tsv  OCR có toạ độ (OCR_TSV=1 swift tool/pdf_tool.swift ocr …)
  content/raw/ets2024/keys.json       đáp án (tool/ets2024/extract_keys.py)
  content/raw/ets2024/overrides.json  sửa tay {"test": {"câu": {"content", "options", "passage", "transcript"}}}
  content/raw/ets2024/overrides/testNN.json  sửa tay riêng 1 đề {"câu": {…}} (ghi đè overrides.json)
  content/raw/ets2024/tr.tsv          OCR sách giải YBM (script nghe): transcript Part 1–4, lọc tiếng Hàn
  content/raw/ets2024/audio_cut/      audio Test 3/4 cắt lại (.m4a, chép thẳng)
  content/raw/ets2024/explanations/testNN*.json  giải thích tiếng Việt {"câu": "…"} (chưa có thì để trống)

    python3 tool/ets2024/build.py 1          # → content/tests/ets2024_test01/
    python3 tool/ets2024/build.py 1-10
"""
import glob
import json
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'ets'))
import build_ets as E  # noqa: E402

ROOT = os.path.join(HERE, '..', '..')
C = os.path.join(ROOT, 'content')
SRC = os.path.join(C, 'ETS2024')
E.LC_PDF = os.path.join(SRC, 'FULL TEST  LC.pdf')
E.RC_PDF = os.path.join(SRC, 'FULL TEST RC.pdf')
E.WORK = os.path.join(C, 'raw', 'ets2024')
LC_PAGES, RC_PAGES = 13, 29

_AUDIO_INDEX = None


def audio_src(test, name):
    """Tìm Test_NN-<name>.mp3 ở mọi thư mục con của content/ETS2024 (thư mục đặt tên không thống nhất)."""
    global _AUDIO_INDEX
    if _AUDIO_INDEX is None:
        _AUDIO_INDEX = {}
        # Test 3/4: bản cắt lại (đã là AAC 48 kbps) ưu tiên hơn mp3 gốc
        for p in glob.glob(os.path.join(E.WORK, 'audio_cut', '**', 'Test_*.m4a'), recursive=True):
            _AUDIO_INDEX.setdefault(os.path.splitext(os.path.basename(p))[0], p)
        for p in glob.glob(os.path.join(SRC, '**', 'Test_*.mp3'), recursive=True):
            _AUDIO_INDEX.setdefault(os.path.splitext(os.path.basename(p))[0], p)
    return _AUDIO_INDEX.get(f'Test_{test:02d}-{name}')


def audio(test, name, out_dir, warn):
    """Audio nhóm → a<name>.m4a (AAC mono 48 kbps như ETS 2026). Thiếu nguồn vẫn ghi tên để bổ sung sau."""
    dst_name = f'a{name}.m4a'
    dst = os.path.join(out_dir, dst_name)
    src = audio_src(test, name)
    if src and not os.path.exists(dst):
        if src.endswith('.m4a'):
            shutil.copyfile(src, dst)
        else:
            E.run('afconvert', '-f', 'm4af', '-d', 'aac', '-c', '1', '-b', '48000', src, dst)
    if not os.path.exists(dst):
        warn.append(f'Audio thiếu: Test_{test:02d}-{name}')
    return dst_name


def merge_rects(rects, gap=0.06):
    """Ảnh có mảng trắng lớn (tuyết, trời) bị dò thành 2 khối chồng cột → gộp khối liền nhau theo chiều dọc."""
    if len(rects) <= 2:  # mỗi trang Part 1 có 2 ảnh – chỉ gộp khi dò thừa
        return list(rects)
    out = []
    for x, y, w, h in sorted(rects, key=lambda r: r[1]):
        if out:
            px, py, pw, ph = out[-1]
            overlap = min(px + pw, x + w) - max(px, x)
            if overlap > 0.5 * min(pw, w) and y - (py + ph) < gap:
                nx, ny = min(px, x), py
                out[-1] = (nx, ny, max(px + pw, x + w) - nx, max(py + ph, y + h) - ny)
                continue
        out.append((x, y, w, h))
    return out


def fix_part6_blanks(text, a, b):
    """Chỗ trống Part 6: số câu đứng riêng ("131", "131.", "-132.", "—133") → ---(131)---."""
    return re.sub(r'(?<![\w$.,])[-—–_•]*\s?(1[34]\d)\.?(?![\w%])',
                  lambda m: f' ---({m.group(1)})---' if a <= int(m.group(1)) <= b else m.group(0), text)


DASH = re.compile(r'(?<![\w()-])[-—–*]{1,3}\s?\.?(?=\s|$)(?!-)')


def fill_part6_blanks(text, a, b):
    """Chỗ trống mất số (OCR chỉ còn "-." / "--") → điền số còn thiếu vào gạch trơ trọi đầu tiên nằm giữa
    chỗ trống trước và sau nó. Chỉ là phỏng đoán vị trí – cần soát với ảnh gốc."""
    for n in range(a, b + 1):
        if f'---({n})---' in text:
            continue
        prev = max((text.find(f'---({k})---') + 9 for k in range(a, n) if f'---({k})---' in text), default=0)
        nxt = min((text.find(f'---({k})---') for k in range(n + 1, b + 1) if f'---({k})---' in text), default=len(text))
        for m in DASH.finditer(text, prev, nxt):
            if not re.search(r'---\(\d+\)---', text[max(0, m.start() - 3):m.end() + 3]):
                text = text[:m.start()] + f' ---({n})--- ' + text[m.end():]
                break
    return re.sub(r'[ \t]{2,}', ' ', text)


def norm_blank5(stem):
    """Part 5: thêm dạng chỗ trống 1 gạch dính chữ ("will-.", "The-") mà build_ets.norm_blank bỏ sót."""
    out = E.norm_blank(stem)
    if out and '-------' not in out:
        out = re.sub(r'(?<=\w)-[.\-_…]+(?=\s|$)', ' -------', out, count=1)            # "excellent-.....", "clothes-.."
    if out and '-------' not in out:
        out = re.sub(r'(?<=\w)-[._]?(?=\s|$)', ' -------', out, count=1)
    if out and '-------' not in out:  # "of-furniture": gạch dính sau hư từ không phải từ ghép
        out = re.sub(r'\b(of|the|to|a|an|is|be|for|and|in|on|with|by|at|are|was|its|their)-(?=[a-z])',
                     r'\1 ------- ', out, count=1)
        out = re.sub(r'\s+', ' ', out).strip()
    return out


def fix_insert_options(q):
    """Câu chèn câu Part 7: OCR đọc "[2]" thành "i2]", "(3]"… → chuẩn ["[1]", "[2]", "[3]", "[4]"]."""
    # Dạng câu này đáp án luôn là 4 vị trí [1]–[4] → điền thẳng, kể cả khi OCR mất dòng (C)/(D).
    if q and 'positions marked' in (q.get('content') or ''):
        q['options'] = ['[1]', '[2]', '[3]', '[4]']


# ------------------------------------------------------------------ transcript (sách giải YBM, tr.tsv)
TAG_ANY = re.compile(r'(?<![A-Za-z])([MW])[-–]\s?(Am|Br|Cn|Au)\b\s*/?\s*')
FOOT_Y = 0.93
_TR_PAGES = None


def tr_pages(test):
    """Trang tr.tsv của đề: từ trang đầu đề này (nhận qua tiêu đề/chân trang "TEST n") tới trước trang đầu đề sau.
    (build_ets.transcript_pages lẫn trang lạc – vd Test 1 dính trang 286 – nên chỉ lấy trang đầu rồi cắt liền.)"""
    global _TR_PAGES
    if _TR_PAGES is None:
        starts = {t: min(E.transcript_pages(t) or {10 ** 6}) for t in range(1, 11)}
        last = max(int(r.split('\t')[0]) for r in open(os.path.join(E.WORK, 'tr.tsv'), encoding='utf-8')
                   if r.count('\t') >= 4)
        _TR_PAGES = {t: set(range(starts[t], (starts[t + 1] if t < 10 else last + 1))) for t in range(1, 11)}
    return _TR_PAGES[test]


def merge_rows(lines, tol=0.006):
    """Gộp mảnh cùng hàng (nhãn giọng "M-Au" OCR thành dòng riêng, lệch y vài phần nghìn) theo thứ tự x.
    Dòng có Hangul giữ riêng – dùng làm mốc hết lời thoại tiếng Anh."""
    rows = []
    for ln in lines:
        if ln.y > FOOT_Y:
            continue
        prev = rows[-1] if rows else None
        if (prev and not E.HANGUL.search(ln.text) and not E.HANGUL.search(prev[0].text)
                and prev[0].page == ln.page and prev[0].col == ln.col and abs(ln.y - prev[0].y) < tol):
            prev.append(ln)
        else:
            rows.append([ln])
    return [E.Line(r[0].page, r[0].col, r[0].y, min(l.x for l in r),
                   ' '.join(l.text for l in sorted(r, key=lambda l: l.x))) for r in rows]


def en_ok(t):
    latin = sum(ord(c) < 0x180 or c in '’‘“”—–…' for c in t) / max(1, len(t))
    return not E.JUNK.search(t) and latin > 0.95 and sum(c.isalpha() for c in t) >= 0.5 * len(t)


def tr_item(block, count):
    """Khối 1 câu Part 1/2 (sau dòng số câu): câu hỏi (Part 2) + (A)…(C/D). Bỏ nhãn giọng, dừng ở rác OCR tiếng Hàn."""
    stem, opts, cur, prev = [], {}, None, None
    for ln in block:
        near = prev is not None and prev.page == ln.page and prev.col == ln.col and 0 < ln.y - prev.y < 0.025
        prev = ln
        if E.HANGUL.search(ln.text):
            if cur:
                break
            stem = []
            continue
        t = TAG_ANY.sub('', ln.text).strip(' /')
        if not t or t.isdigit():
            continue
        om = E.OPT.match(t)
        good = om and t.startswith('(') and en_ok(om.group(2)) and '(' not in om.group(2)
        if good and om.group(1) == 'A' and cur and len(opts) < count:
            opts, cur = {}, None  # chuỗi trước là rác OCR → bắt đầu lại
        if good and om.group(1) == chr(ord(cur or '@') + 1):
            cur = om.group(1)
            opts[cur] = om.group(2)
            continue
        if cur is None:
            if en_ok(t) and len(t) > 2 and not re.match(r'^\(?[A-D]\)', t):
                stem.append(t)
            else:
                stem = []  # rác / đáp án câu trước: câu hỏi phải liền ngay trước (A)
            continue
        if near and not re.search(r'[.?!"]$', opts[cur]) and re.match(r'^[a-z0-9"\'(]', t) and en_ok(t):
            opts[cur] += ' ' + t
        else:
            break
    tidy = lambda x: E.clean(re.sub(r'(?<=[.?!])\s+\d{1,2}$', '', x))  # số câu sau dính cuối dòng
    return E.clean(' '.join(stem)), [tidy(opts[c]) for c in 'ABCD'[:count] if c in opts]


def strip_hints(t, lo, hi):
    """Bỏ số gợi ý câu hỏi chèn trong lời thoại: "441 know" → "I know", "49l'd" → "I'd", "46if" → "if"."""
    nums = '|'.join(str(n) for n in range(lo, hi + 1))
    t = re.sub(rf'\b({nums})(?:,\s?({nums}))*\s?[1lI|](?=\s|[\'’])', 'I', t)
    t = re.sub(rf'\b({nums})0(?=n\b)', 'O', t)                       # "740n" → "On"
    t = re.sub(r'(?<!\S)[\d]*[°º®][\d°º®]*\s*', '', t)                  # "5°I'm", "®1 Eighty", "1ºº please"
    t = re.sub(rf'(?<![\d$.,:])\b({nums})(?:,\s?({nums}))*\s*(?=[A-Za-z"\'(])', '', t)
    t = re.sub(r'(?<![\d$.,:-])\b\d{1,3}(?=[a-z]{2})', '', t)              # số gợi ý OCR sai dính chữ: "35to"
    t = re.sub(r'^\d{1,3}\s+(?=[A-Z])', '', t)
    t = re.sub(rf'\s+({nums})$', '', t)
    t = re.sub(r'\bl(?=(agree|am|have|think|will|was|can|know|hope|need|want|just|don\'t|didn\'t)\b)', 'I ', t)                              # "7 Thanks …" đầu bài nói
    t = re.sub(r'\blt\b', 'It', t)
    t = re.sub(r'\bAlI\b', 'All', t).replace("I'II", "I'll").replace("l'll", "I'll")
    return re.sub(r"(?<![A-Za-z])l'(m|d|ve|ll)\b", r"I'\1", t)


def tr_talk(block, lo, hi):
    """Lời thoại Part 3/4: dòng "W-Am …" mở lượt mới, dòng thụt lề nối tiếp; dừng ở dòng tiếng Hàn đầu tiên
    hoặc khoảng trống lớn trong cùng cột. 3 người: 2 giọng nam (khác vùng) → M1/M2, tương tự W1/W2."""
    turns, prev = [], None
    for ln in block:
        if E.HANGUL.search(ln.text) or re.search(r'Paraphrasing', ln.text):
            if turns:
                break
            continue
        if turns and prev and prev.page == ln.page and prev.col == ln.col and ln.y - prev.y > 0.03:
            break
        t = re.sub(r'(?<=[\s,.])\|(?=\s)', 'I', ln.text)  # "Where can | tell" → "I"
        tm = E.TAG.match(t)
        prev = ln
        if tm:
            turns.append([tm.group(3), tm.group(4), tm.group(5)])
        elif not turns and en_ok(t):
            turns.append([None, None, t])  # lượt đầu mất nhãn: đoán giới tính ngược với lượt sau
        elif turns and en_ok(t) and not (re.search(r'[.?!]["\']?$', turns[-1][2]) and re.match(r'^[a-z]', t)):
            turns[-1][2] += ' ' + t
    if not turns:
        return ''
    if turns[0][0] is None:
        nxt = next((g for g, _, _ in turns[1:] if g), None)
        if nxt is None:
            turns[0][0] = 'W'
        else:
            turns[0][0] = 'W' if nxt == 'M' else 'M'
            same = [acc for g, acc, _ in turns[1:] if g == turns[0][0]]
            turns[0][1] = same[0] if same else None
    voices = {}
    for g, acc, _ in turns:
        voices.setdefault(g, [])
        if acc not in voices[g]:
            voices[g].append(acc)
    out = []
    for g, acc, text in turns:
        text = E.clean(strip_hints(TAG_ANY.sub('', text).strip(), lo, hi))
        if not text:
            continue
        label = g + (str(voices[g].index(acc) + 1) if len(voices[g]) > 1 else '')
        if out and out[-1][0] == label:
            out[-1][1] += ' ' + text
        else:
            out.append([label, text])
    if len(out) == 1 or lo >= 71:  # Part 4: 1 người nói (nhãn khác chỉ là OCR lạc)
        return ' '.join(t for _, t in out)
    return '\n'.join(f'{l}: {t}' for l, t in out)


def norm_line(t):
    """OCR đọc "I" thành "|" / "[": "Where can | tell", "42| know", "['ll be"."""
    if E.HANGUL.search(t):
        return t
    t = re.sub(r'(?<![A-Za-z])\|(?=\s|[\'’]|$)', 'I', t)
    return re.sub(r'[\[\]](?=[\'’](ll|m|d|ve)\b)', 'I', t)


def assign_runs(runs, first, count):
    """Gán số câu cho các chuỗi đáp án theo mốc (số câu in trước chuỗi); giữa 2 mốc mà số chuỗi khớp số câu
    thì gán tuần tự – 1 câu mất số không làm lệch các câu sau."""
    out = {}
    known = [(k, r['num']) for k, r in enumerate(runs) if r['num'] and first <= r['num'] < first + count]
    anchors = [(-1, first - 1)] + known + [(len(runs), first + count)]
    for (ka, na), (kb, nb) in zip(anchors, anchors[1:]):
        if nb <= na:
            continue
        if kb - ka == nb - na:
            for off, k in enumerate(range(ka + 1, kb)):
                out[na + 1 + off] = runs[k]
        if kb < len(runs):
            out[nb] = runs[kb]
    return out


def parse_transcript24(test):
    """→ (p1p2 {câu: (câu hỏi, [đáp án])}, {câu đầu nhóm: lời thoại})."""
    lines = [E.Line(l.page, l.col, l.y, l.x, norm_line(l.text))
             for l in merge_rows(E.load_tsv('tr.tsv', tr_pages(test), keep_numbers=True))]
    # Part 3/4: câu hỏi in lại "41" + "Why is …?" ; lời thoại nhóm a nằm giữa câu a-1 và câu a
    head32 = next((i for i, l in enumerate(lines) if re.match(r'^32\s*[-–]\s*34', l.text)), None)
    qline, pos = {}, head32 or 0
    for n in range(32, 101):
        for i in range(pos, len(lines) - 1):
            nxt = lines[i + 1].text
            # số câu đứng riêng, hoặc dính cuối hàng trước ("… offer to do? 47")
            if (re.match(rf'^(.*[?.]\s+)?{n}$', lines[i].text) and re.match(r'^[A-Z][a-z]', nxt) and en_ok(nxt)
                    and len(nxt) > 10):
                qline[n] = pos = i
                break
    p34_from = head32 if head32 is not None else qline.get(32, len(lines))
    # Part 1/2: mỗi câu = chuỗi (A)→(C/D); số câu ("7" hoặc "7 W-Br …") in trước chuỗi làm mốc
    runs, num, bound = [], None, 0
    for i in range(p34_from):
        t = TAG_ANY.sub('', lines[i].text).strip(' /')
        m = re.match(r'^(\d{1,2})(?:\s+|$)', lines[i].text)
        if m and TAG_ANY.search(' '.join(l.text for l in lines[i:i + 4])) and 1 <= int(m.group(1)) <= 31:
            num, bound = int(m.group(1)), i
            continue
        om = E.OPT.match(t)
        if om and t.startswith('(A)') and en_ok(om.group(2)) and '(' not in om.group(2):
            nxt = next((k for k in range(i + 1, p34_from) if re.match(r'^\(A\)', TAG_ANY.sub('', lines[k].text).strip())
                        ), p34_from)
            block = [E.Line(l.page, l.col, l.y, l.x, re.sub(r'^\d{1,2}\s+(?=[MW][-–])', '', l.text))
                     for l in lines[bound + (1 if num else 0):nxt]] if bound <= i else lines[i:nxt]
            stem, opts = tr_item(block, 4)
            runs.append({'num': num, 'stem': stem if len(opts) == 3 else '', 'opts': opts})
            num, bound = None, i + 1
    # Part 1 = các chuỗi trước mốc Part 2 đầu tiên (đủ 6 chuỗi thì gán tuần tự, kể cả chuỗi thiếu đáp án)
    cut = next((k for k, r in enumerate(runs) if r['num'] and 7 <= r['num'] <= 31), None)
    if cut is not None and cut == 6:
        p1, p2 = runs[:6], runs[6:]
        for k, r in enumerate(p1):
            r['num'] = k + 1
    else:
        p1 = [r for r in runs if len(r['opts']) == 4][:6]
        p2 = [r for r in runs if r not in p1]
    for r in p2:  # Part 2 chỉ (A)–(C): bỏ phần dư nếu lỡ dính
        r['opts'] = r['opts'][:3]
    p1p2 = {n: (r['stem'], r['opts']) for grp, first, cnt in ((p1, 1, 6), (p2, 7, 25))
            for n, r in assign_runs(grp, first, cnt).items()}
    talks = {}
    for a in range(32, 101, 3):
        # mốc đầu: câu hỏi gần nhất của nhóm trước; mốc cuối: câu a (thiếu thì câu a+1, a+2, rồi nhóm sau)
        start = next((qline[n] for n in (a - 1, a - 2, a - 3) if n in qline), head32 or 0) if a > 32 else (head32 or 0)
        end = next((qline[n] for n in (a, a + 1, a + 2, a + 3) if n in qline), None)
        if end is None or end <= start:
            continue
        # tiêu đề "50-52" (OCR có khi đọc sai số sau); câu hỏi in lại có khi mang số sai → tiêu đề nằm sau `end`
        limit = next((qline[n] for n in range(a + 1, a + 6) if qline.get(n, 0) > end), end)
        head = next((i for i in range(start, limit) if re.match(rf'^{a}\s*[-–]\s*\d', lines[i].text)), None)
        if head is not None and head > end:
            end = next((v for v in sorted(qline.values()) if v > head), len(lines))
        block = lines[(head if head is not None else start) + 1:end]
        first = next((k for k, ln in enumerate(block) if E.TAG.match(ln.text)
                      and not re.match(r'^\s*\(', E.TAG.match(ln.text).group(5))), None)
        if first is not None:
            # nhãn giọng của lượt đầu bị OCR mất: các dòng tiếng Anh ngay sau tiêu đề nhóm vẫn là lượt đầu
            pre = []
            if head is not None:
                for ln in block[:first]:
                    if E.HANGUL.search(ln.text) or not en_ok(ln.text):
                        pre = []
                        break
                    pre.append(ln)
            talks[a] = tr_talk(pre + block[first:], a, a + 2)
    return p1p2, talks


def load_explanations(test):
    out = {}
    for p in sorted(glob.glob(os.path.join(E.WORK, 'explanations', f'test{test:02d}*.json'))):
        out.update(json.load(open(p, encoding='utf-8')))
    return out


class _Line24(E.Line):
    """Dòng OCR bị xếp "F" (cả trang) nhưng bắt đầu ở nửa phải – thường là "133. (A) last" của cột phải
    đáp án Part 6/7 – coi là cột phải để không xé chuỗi đáp án của cột trái."""
    def __init__(self, page, col, y, x, text):
        right = col == 'F' and x > 0.4 and re.match(r'^(\d{3}\.\s*)?\([A-D]\)', text)
        super().__init__(page, 'R' if right else col, y, x, text)


def load_rc(pages):
    orig = E.Line
    E.Line = _Line24
    try:
        return E.load_tsv('rc300.tsv', pages)
    finally:
        E.Line = orig


def fix_insert_markers(text):
    """Vị trí chèn câu Part 7 OCR sai: "— 14] -.", "-4-.", "[|]" → "— [4] —" (chỉ ngay sau dấu kết câu)."""
    text = re.sub(r'\[[|l]\]', '[1]', text)
    return re.sub(r'(?<=[.?!"’]\s)[—-]\s?[\[(|1l]?\s?([1-4])\s?[\])|]?\s?[—-]',
                  lambda m: f'— [{m.group(1)}] —', text)


def build(test, keys):
    out_dir = os.path.join(C, 'tests', f'ets2024_test{test:02d}')
    os.makedirs(out_dir, exist_ok=True)
    warn = []
    base_lc, base_rc = LC_PAGES * (test - 1), RC_PAGES * (test - 1)
    lc_pages = set(range(base_lc + 1, base_lc + LC_PAGES + 1))
    rc_pages = set(range(base_rc + 1, base_rc + RC_PAGES + 1))
    key = {int(k): v for k, v in keys[str(test)].items()}
    groups = []
    p1p2, talks = parse_transcript24(test)
    explanations = load_explanations(test)
    if explanations:  # giải thích trích nguyên văn câu tiếng Anh → bỏ transcript Part 1/2 gán nhầm câu
        p1p2 = {**{k: v for k, v in p1p2.items() if k > 31}, **E.align_by_explanations(p1p2, explanations)}

    # ----- Part 1 (1–6): ảnh ở trang 3–5 của đề (trang 2 là ví dụ mẫu)
    photo_rects = []
    for pg in (base_lc + 3, base_lc + 4, base_lc + 5):
        photo_rects += [(pg, r) for r in merge_rects(E.photos(pg))]
    if len(photo_rects) != 6:
        warn.append(f'Part 1: dò được {len(photo_rects)}/6 ảnh')
    for n in range(1, 7):
        g = {'part': 1, 'questions': [{'number': n, 'answer': key.get(n, '?')}]}
        if n <= len(photo_rects):
            pg, (x, y, w, h) = photo_rects[n - 1]
            name = f'p1_{n}.jpg'
            E.crop(E.LC_PDF, pg, x - 0.01, y - 0.01, w + 0.02, h + 0.02, os.path.join(out_dir, name), 160)
            g['image'] = name
        g['audio'] = audio(test, f'{n:02d}', out_dir, warn)
        opts = p1p2.get(n, ('', []))[1]
        if len(opts) == 4:
            g['transcript'] = '\n'.join(f'({c}) {o}' for c, o in zip('ABCD', opts))
        else:
            warn.append(f'Câu {n}: transcript thiếu ({len(opts)}/4 đáp án)')
        groups.append(g)

    # ----- Part 2 (7–31): audio + transcript (câu hỏi + (A)–(C))
    for n in range(7, 32):
        g = {'part': 2, 'questions': [{'number': n, 'answer': key.get(n, '?')}],
             'audio': audio(test, f'{n:02d}', out_dir, warn)}
        stem, opts = p1p2.get(n, ('', []))
        if stem and len(opts) == 3:
            g['transcript'] = f'{stem}\n' + '\n'.join(f'({c}) {o}' for c, o in zip('ABC', opts))
        else:
            warn.append(f'Câu {n}: transcript chưa đủ (câu hỏi={bool(stem)}, {len(opts)}/3)')
        groups.append(g)

    # ----- Part 3/4 (32–100): câu hỏi từ sách LC
    lc = E.load_tsv('lc.tsv', lc_pages)
    lq = E.parse_questions(lc, 32, 100)
    for start in range(32, 101, 3):
        nums = [start, start + 1, start + 2]
        part = 3 if start < 71 else 4
        qs = []
        for n in nums:
            q = lq.get(n)
            if not q or len(q['options']) != 4:
                warn.append(f'Câu {n}: OCR câu hỏi thiếu ({0 if not q else len(q["options"])}/4 đáp án)')
            qs.append({'number': n, 'answer': key.get(n, '?'), 'content': q and q['content'],
                       'options': q['options'] if q else []})
        g = {'part': part, 'questions': qs, 'audio': audio(test, f'{start}-{start + 2}', out_dir, warn)}
        if talks.get(start):
            g['transcript'] = talks[start]
        else:
            warn.append(f'Nhóm {start}-{start + 2}: chưa lấy được transcript')
        if any('graphic' in (q.get('content') or '').lower() for q in qs) and lq.get(start):
            g['image'] = E.graphic(lc, lq[start]['first'], E.LC_PDF, out_dir, f'g{start}.jpg', warn)
        groups.append(g)

    # ----- Part 5 (101–130)
    rc = load_rc(rc_pages)
    rq = E.parse_questions(rc, 101, 130)
    for n in range(101, 131):
        q = rq.get(n)
        if not q or len(q['options']) != 4:
            warn.append(f'Câu {n}: OCR thiếu ({0 if not q else len(q["options"])}/4 đáp án)')
        groups.append({'part': 5, 'questions': [{'number': n, 'answer': key.get(n, '?'),
                                                 'content': q and norm_blank5(q['content']),
                                                 'options': q['options'] if q else []}]})

    # ----- Part 6 (131–146) + Part 7 (147–200): nhóm theo "Questions a-b refer to …"
    headers = []
    for i, ln in enumerate(rc):
        m = re.match(r'^Questions?\s+(\d{3})\s*[-–]\s*(\d{3})\s+refer', ln.text, re.I)
        if m:
            headers.append((i, int(m.group(1)), int(m.group(2))))
    q6 = E.parse_questions(rc, 131, 146, need_stem=False)
    q7 = E.parse_questions(rc, 147, 200)
    found = {(a, b) for _, a, b in headers}
    for k, (i, a, b) in enumerate(headers):
        part = 6 if a < 147 else 7
        qmap = q6 if part == 6 else q7
        first = qmap.get(a)
        passage_lines = E.region_lines(rc, rc[i], first['first'] if first else None,
                                       rc[headers[k + 1][0]] if k + 1 < len(headers) else None)
        text = E.join_paragraphs(passage_lines)
        if part == 6:
            text = fill_part6_blanks(fix_part6_blanks(text, a, b), a, b)
        qs = []
        for n in range(a, b + 1):
            q = qmap.get(n)
            fix_insert_options(q)
            if not q or len(q['options']) != 4:
                warn.append(f'Câu {n}: OCR thiếu ({0 if not q else len(q["options"])}/4 đáp án)')
            qs.append({'number': n, 'answer': key.get(n, '?'), 'content': q and q['content'],
                       'options': q['options'] if q else []})
        if part == 7 and any('positions marked' in (q.get('content') or '') for q in qs):
            text = fix_insert_markers(text)
        g = {'part': part, 'passage': text, 'questions': qs}
        if part == 7 and passage_lines:
            g['image'] = E.passage_image(rc[i], passage_lines, out_dir, f'r{a}.jpg')
        groups.append(g)
    for a, b in [(131, 134), (135, 138), (139, 142), (143, 146)]:
        if (a, b) not in found:
            warn.append(f'Không tìm thấy tiêu đề nhóm Part 6 {a}-{b}')

    # ----- sửa tay
    ov_path = os.path.join(E.WORK, 'overrides.json')
    overrides = json.load(open(ov_path)).get(str(test), {}) if os.path.exists(ov_path) else {}
    ov_test = os.path.join(E.WORK, 'overrides', f'test{test:02d}.json')  # sửa riêng từng đề {"câu": {…}}
    if os.path.exists(ov_test):
        for n, fix in json.load(open(ov_test)).items():
            overrides[n] = {**overrides.get(n, {}), **fix}
    for g in groups:
        for q in g['questions']:
            fix = overrides.get(str(q['number']))
            if fix:
                q.update({k: v for k, v in fix.items() if k in ('content', 'options')})
                for k in ('passage', 'transcript'):
                    if k in fix:
                        g[k] = fix[k]
                warn[:] = [w for w in warn if not w.startswith(f'Câu {q["number"]}:')]

    # ----- giải thích tiếng Việt: content/raw/ets2024/explanations/testNN*.json {"câu": "…"}
    for g in groups:
        for q in g['questions']:
            if explanations.get(str(q['number'])):
                q['explanation'] = explanations[str(q['number'])]

    # ----- thẻ dạng câu (Part 2 theo câu hỏi trong transcript)
    from tagging import tag_question
    for g in groups:
        for q in g['questions']:
            first = (g.get('transcript') or '').split('\n')[0] if g['part'] == 2 else None
            q['tags'] = tag_question(g['part'], q.get('content'), q.get('options'), g.get('passage'), first)
            if g['part'] == 7 and q['number'] >= 176 and 'multi-passage' not in q['tags']:
                q['tags'].append('multi-passage')

    # ----- OCR đọc "I" thành "l"
    def fix_i(text):
        if not text:
            return text
        text = re.sub(r"(?<![A-Za-z])l'(ve|m|d|ll)\b", r"I'\1", text)
        text = re.sub(r"'I[l|I]\b|'Il\b", "'ll", text)
        text = re.sub(r'\bolt\b', 'It', text)
        return re.sub(r"(?<![A-Za-z'’])l (?=[a-z])", 'I ', text)
    for g in groups:
        for k in ('passage', 'transcript'):
            if g.get(k):
                g[k] = fix_i(g[k])
        for q in g['questions']:
            q['content'] = fix_i(q.get('content'))
            if q.get('options'):
                q['options'] = [fix_i(o) for o in q['options']]

    # ----- kiểm tra + dọn trường rỗng
    numbers = [q['number'] for g in groups for q in g['questions']]
    missing = sorted(set(range(1, 201)) - set(numbers))
    if missing:
        warn.append(f'Thiếu câu: {missing}')
    for g in groups:
        for q in g['questions']:
            if q['answer'] not in 'ABCD' or len(q['answer']) != 1:
                warn.append(f'Câu {q["number"]}: thiếu đáp án')
            if not q.get('content'):
                q.pop('content', None)
            if not q.get('options'):
                q.pop('options', None)
        for k in [k for k, v in g.items() if v is None]:
            g.pop(k)
    groups.sort(key=lambda g: g['questions'][0]['number'])

    test_json = {
        'title': f'ETS 2024 – Test {test}',
        'source': 'ETS 2024',
        'description': 'Đề ETS 2024 (YBM 기출문제집 4) chuyển từ sách bằng OCR. Đoạn văn Part 7 có kèm ảnh gốc để đối chiếu.',
        'is_free': False,
        'groups': groups,
    }
    with open(os.path.join(out_dir, 'test.json'), 'w', encoding='utf-8') as f:
        json.dump(test_json, f, ensure_ascii=False, indent=1)
    size = sum(os.path.getsize(os.path.join(out_dir, x)) for x in os.listdir(out_dir)) / 1e6
    print(f'Test {test}: {len(groups)} nhóm, {len(numbers)} câu, {size:.1f} MB, {len(warn)} cảnh báo', file=sys.stderr)
    for w in warn:
        print(f'  ⚠ {w}', file=sys.stderr)
    return warn


if __name__ == '__main__':
    arg = sys.argv[1] if len(sys.argv) > 1 else '1'
    a, _, b = arg.partition('-')
    keys = json.load(open(os.path.join(E.WORK, 'keys.json')))
    total = 0
    for t in range(int(a), int(b or a) + 1):
        total += len(build(t, keys))
    print(f'Tổng cảnh báo: {total}', file=sys.stderr)
