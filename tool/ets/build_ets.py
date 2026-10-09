#!/usr/bin/env python3
"""Chuyển bộ sách ETS 2026 (PDF scan + audio) thành đề theo định dạng tool/import_test.dart.

Đầu vào (đặt sẵn trong content/, đều bị .gitignore):
  content/LISTENING/LISTENING ETS 2026.pdf   14 trang / đề, đáp án LC ở trang 142–144
  content/LISTENING/TRANSCRIPT.pdf           lời thoại Part 1–4 (Anh + Hàn)
  content/LISTENING/Audio/E26-Tnn-*.mp3      audio đã cắt theo câu / nhóm
  content/READING/READING ETS 2026.pdf       30 trang / đề, đáp án RC ở trang 302–304
  content/raw/ets2026/{lc,rc,tr}.tsv         OCR có toạ độ (OCR_TSV=1 swift tool/pdf_tool.swift ocr ...)
  content/raw/ets2026/keys.json              đáp án {test: {câu: chữ}} (tool/ets/extract_keys.py + soát tay)

    python3 tool/ets/build_ets.py 1          # dựng Test 1 → content/tests/ets2026_test01/
    python3 tool/ets/build_ets.py 1-10       # dựng cả bộ

Báo cáo các câu thiếu/nghi ngờ ra stderr để soát tay.
"""
import json
import os
import re
import subprocess
import sys
from collections import defaultdict

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
C = os.path.join(ROOT, 'content')
LC_PDF = os.path.join(C, 'LISTENING', 'LISTENING ETS 2026.pdf')
RC_PDF = os.path.join(C, 'READING', 'READING ETS 2026.pdf')
AUDIO = os.path.join(C, 'LISTENING', 'Audio')
WORK = os.path.join(C, 'raw', 'ets2026')
TOOL = ['swift', os.path.join(ROOT, 'tool', 'pdf_tool.swift')]

HANGUL = re.compile(r'[가-힣㄰-㆏]')
NOISE = re.compile(r'^(GO ON TO THE NEXT PAGE|TEST(\s*\d+)?(\s+\d+)?|\d{1,3}|PART\s*\d|‖)$', re.I)
Q_START = re.compile(r'^(\d{1,3})[.,]\s*(.*)$')
OPT = re.compile(r'^\(?([A-D])\)\s*(.*)$')
OPT_LOOSE = re.compile(r'^\(([A-D0OQ8])\)\s*(.*)$')  # OCR hay đọc (C)/(D) thành (0)/(O)
Q_STRICT = re.compile(r'^\d{2,3}\.\s')  # đầu câu hỏi thật, vd "131. "
TAG = re.compile(r'^(?:(\d{1,3})(?:\s*[-–]\s*(\d{1,3}))?\s*)?([MW])[-–]\s?(Am|Br|Cn|Au)\b(.*)$')
SPEAKER = re.compile(r'^([MW])[.:]?\s+(.*)$', re.I)


class Line:
    __slots__ = ('page', 'col', 'y', 'x', 'text', 'used')

    def __init__(self, page, col, y, x, text):
        self.page, self.col, self.y, self.x, self.text, self.used = page, col, y, x, text, False

    def __repr__(self):
        return f'<{self.page}{self.col} {self.y:.3f} {self.text!r}>'


def load_tsv(name, pages, keep_numbers=False):
    by_page = defaultdict(list)
    with open(os.path.join(WORK, name), encoding='utf-8') as f:
        for raw in f:
            parts = raw.rstrip('\n').split('\t')
            if len(parts) < 5:
                continue
            p = int(parts[0])
            if p in pages:
                by_page[p].append(Line(p, parts[1], float(parts[2]), float(parts[3]), parts[4].strip()))
    out = []
    for p in sorted(by_page):
        # Thứ tự đọc 2 cột: gặp dòng full-width thì xả cột trái rồi cột phải.
        left, right = [], []
        for ln in sorted(by_page[p], key=lambda l: l.y):
            if ln.col == 'L':
                left.append(ln)
            elif ln.col == 'R':
                right.append(ln)
            else:
                out += left + right + [ln]
                left, right = [], []
        out += left + right
    # transcript cần giữ dòng chỉ có số ("9") – đó là số câu Part 1/2
    return [l for l in out if l.text and (not NOISE.match(l.text) or (keep_numbers and l.text.isdigit()))]


def is_continuation(prev, ln, min_x):
    """Dòng nối tiếp câu hỏi/đáp án: cùng trang + cột, ngay bên dưới, thụt lề ≥ min_x."""
    if ln.page != prev.page or ln.col != prev.col:
        return False
    dy = ln.y - prev.y
    if abs(dy) < 0.005:  # cùng hàng: OCR tách 1 dòng thành 2 khúc → phải nằm bên phải
        return ln.x > prev.x + 0.02 and not OPT_LOOSE.match(ln.text) and not Q_STRICT.match(ln.text)
    if not (0 < dy < 0.04):
        return False
    return ln.x >= min_x and not OPT.match(ln.text) and not OPT_LOOSE.match(ln.text) \
        and not Q_STRICT.match(ln.text)


def parse_questions(lines, lo, hi, need_stem=True):
    """Tìm câu lo..hi: '{n}. stem' + (A)…(D). Trả {n: {content, options, first, last}}."""
    qs = {}
    i = 0
    while i < len(lines):
        text = lines[i].text
        fixed = re.sub(r'^[|lI](\d{2})[.,]', r'1\1.', text)  # "|11." → "111."
        if fixed != text and lo <= int(fixed[:3]) <= hi:
            lines[i].text = text = fixed
        m = Q_START.match(text)
        n = int(m.group(1)) if m else -1
        # OCR làm rơi chữ số đầu: "16." → 116 nếu đúng là câu kế tiếp đang chờ
        expected = (max(qs) + 1) if qs else lo
        if 0 < n < 100 and n + 100 == expected and lo <= expected <= hi:
            n = expected
        if not (lo <= n <= hi) or (n in qs and len(qs[n]['options']) >= 2):
            i += 1
            continue
        head = lines[i]
        num_x = head.x  # mốc thụt lề: luôn tính từ vị trí số câu
        stem = m.group(2)
        inline_opt = OPT.match(stem)  # Part 6: "135. (A) ..." cùng dòng
        nxt = lines[i + 1].text if i + 1 < len(lines) else ''
        if not need_stem and not inline_opt and not OPT.match(nxt):
            i += 1  # "137." đứng riêng trong đoạn văn = chỗ trống
            continue
        if not stem and need_stem:
            # OCR tách số câu khỏi dòng đầu: lấy dòng cùng hàng ngay trước hoặc ngay sau
            prev = lines[i - 1] if i else None
            nxt_ln = lines[i + 1] if i + 1 < len(lines) else None
            if prev and not prev.used and prev.page == head.page and abs(prev.y - head.y) < 0.006:
                stem = prev.text
                prev.used = True
            elif nxt_ln and nxt_ln.page == head.page and abs(nxt_ln.y - head.y) < 0.006 \
                    and not OPT.match(nxt_ln.text):
                stem = nxt_ln.text
                head = nxt_ln  # các dòng nối tiếp thẳng hàng với khúc chữ này
                i += 1
        last = head
        j = i + 1
        opts = {}
        if inline_opt:
            stem = ''
            opts['A'] = inline_opt.group(2)
            last = head
        else:
            while j < len(lines) and is_continuation(last, lines[j], num_x + 0.01):
                stem += ' ' + lines[j].text
                last = lines[j]
                j += 1
        cur = 'A' if inline_opt else None
        cur_x = head.x + 0.03 if inline_opt else 0
        while True:
            # dòng nối tiếp của đáp án hiện tại
            while cur and j < len(lines) and is_continuation(last, lines[j], cur_x + 0.01):
                opts[cur] += ' ' + lines[j].text
                last = lines[j]
                j += 1
            if j >= len(lines):
                break
            om = OPT.match(lines[j].text) or OPT_LOOSE.match(lines[j].text)
            if not om or len(opts) >= 4:
                break
            letter = om.group(1)
            if letter not in 'ABCD':  # (0)/(O) → chữ cái kế tiếp
                letter = 'ABCD'[len(opts)]
            if letter in opts:
                break
            cur, cur_x = letter, lines[j].x
            opts[cur] = om.group(2)
            last = lines[j]
            j += 1
        for k in range(i, j):
            lines[k].used = True
        qs[n] = {'content': clean(stem) or None,
                 'options': [clean(opts[c]) for c in 'ABCD' if c in opts],
                 'first': head, 'last': last}
        i = j
    return qs


def clean(s):
    s = re.sub(r'\s+', ' ', s or '').strip()
    s = re.sub(r'\s+TEST(\s*\d+)?$', '', s)  # nhãn "TEST n" ở lề trang lọt vào cuối dòng
    s = spellfix(s)
    s = s.replace(' ,', ',').replace(' .', '.')
    s = re.sub(r'-{3,}|_{3,}|- - -', '-------', s)
    return s


BLANK = re.compile(r'(?<![\w-])[-_.~]*[-_~][-_.~]*(?:\s+[-_.~]*[-_~][-_.~]*)*(?![\w-])')


BLANK_GLUED = re.compile(r'\s*(?:[-–—_]{2,}[-–—_.]*|—|–)\s*')


def norm_blank(stem):
    """Part 5: chỗ trống OCR ra '-', '--', '---_', '—', 'Another--' … → '-------' (chỉ 1 chỗ)."""
    if not stem or '-------' in stem:
        return tidy_blank(stem) if stem else stem
    out = BLANK.sub('-------', stem, count=1)
    if out == stem:  # gạch dính vào chữ: "Another--", "financially—", "workspace-_."
        out = BLANK_GLUED.sub(' ------- ', stem, count=1).strip()
    return tidy_blank(out)


def tidy_blank(s):
    """Gom ký tự thừa quanh chỗ trống: '——-------', '-------_', 'great-------' → ' ------- '."""
    s = re.sub(r'[-–—_~.]*-------[-–—_~]*', '-------', s)
    s = re.sub(r'(?<=\w)-------', ' -------', s)
    s = re.sub(r'-------(?=\w)', '------- ', s)
    return s


try:
    _WORDS = set(w.lower() for w in open('/usr/share/dict/words').read().split())
except OSError:
    _WORDS = set()


_SUFFIX = ['s', 'es', 'ed', 'd', 'ing', 'ly', 'er', 'ers', 'est', 'al', 'ment', 'ments', 'ness', 'ion', 'ions']
SPELL_LOG = []


def _known(w):
    if w in _WORDS:
        return True
    for suf in _SUFFIX:
        if w.endswith(suf):
            base = w[:-len(suf)]
            if base in _WORDS or base + 'e' in _WORDS or (base.endswith('i') and base[:-1] + 'y' in _WORDS):
                return True
            if len(base) > 2 and base[-1] == base[-2] and base[:-1] in _WORDS:
                return True
    return False


# Lỗi OCR rớt chữ cái cuối từ đã kiểm chứng tay. KHÔNG tự đoán bằng từ điển (macOS dict quá cũ:
# women→woment, airline→airliner…). Gặp lỗi mới thì thêm vào đây.
SPELL_FIXES = {
    'charcoa': 'charcoal', 'immediatel': 'immediately', 'appointmen': 'appointment', 'woul': 'would',
    'colleaque': 'colleague', 'contemporar': 'contemporary', 'mornin': 'morning', 'orde': 'order',
    'fabri': 'fabric', 'remotel': 'remotely', 'perso': 'person',
}


def spellfix(text):
    if not text:
        return text

    def fix(m):
        w = m.group(0)
        c = SPELL_FIXES.get(w.lower())
        if not c:
            return w
        SPELL_LOG.append((w, c))
        return c if w.islower() else c.capitalize()
    return re.sub(r"(?<![A-Za-z'’])[A-Za-z]{4,}(?![A-Za-z'’])", fix, text)


def join_paragraphs(lines):
    """Ghép dòng OCR thành đoạn: nối nếu dòng trước chưa kết câu và dòng sau tiếp nội dung."""
    out = []
    for ln in lines:
        t = ln.text
        if out and out[-1] and not re.search(r'[.!?:;]$', out[-1]) and re.match(r'^[a-z0-9(,"\'$]', t):
            out[-1] += ' ' + t
        else:
            out.append(t)
    return '\n'.join(out)


# ------------------------------------------------------------------ media
def run(*args):
    return subprocess.run(list(args), check=True, capture_output=True, text=True).stdout


def crop(pdf, page, x, y, w, h, out, dpi=170):
    x, y = max(0.0, x), max(0.0, y)
    w, h = min(1 - x, w), min(1 - y, h)
    run(*TOOL, 'crop', pdf, str(page), f'{x:.4f}', f'{y:.4f}', f'{w:.4f}', f'{h:.4f}', out, str(dpi))


def photos(page):
    rects = []
    for ln in run(*TOOL, 'photos', LC_PDF, str(page)).splitlines():
        rects.append(tuple(map(float, ln.split())))
    return rects


def audio(test, name, out_dir):
    src = os.path.join(AUDIO, f'E26-T{test:02d}-{name}.mp3')
    if not os.path.exists(src):
        return None
    dst_name = f'a{name}.m4a'
    dst = os.path.join(out_dir, dst_name)
    if not os.path.exists(dst):  # nén: AAC mono 48 kbps (giọng nói vẫn rõ, ~1/3 dung lượng)
        run('afconvert', '-f', 'm4af', '-d', 'aac', '-c', '1', '-b', '48000', src, dst)
    return dst_name


# ------------------------------------------------------------------ transcript
def transcript_pages(test):
    """Trang TRANSCRIPT.pdf thuộc test: dựa vào chân trang 'TEST n <số trang>'."""
    owner, cur = {}, None
    with open(os.path.join(WORK, 'tr.tsv'), encoding='utf-8') as f:
        rows = [r.rstrip('\n').split('\t') for r in f]
    foot = {}
    for r in rows:
        if len(r) >= 5:
            # chân trang "TEST 1 3" hoặc tiêu đề đầu đề "기출 TEST 1" (OCR thành "7| TEST 1")
            m = re.match(r'^\S{0,4}\s*TEST\s*(\d+)\s*\d*$', r[4].strip())
            if m and int(m.group(1)) <= 10:
                foot.setdefault(int(r[0]), int(m.group(1)))
    for p in sorted({int(r[0]) for r in rows if len(r) >= 5}):
        cur = foot.get(p, cur)
        owner[p] = cur
    return {p for p, t in owner.items() if t == test}


GROUP_HEAD = re.compile(r'^(\d{2,3})\s*[-–]')
JUNK = re.compile(r'[#*|=≥≤→÷{}\[\]<>@~^]')


def parse_transcript(test):
    lines = [l for l in load_tsv('tr.tsv', transcript_pages(test), keep_numbers=True)
             if not HANGUL.search(l.text)]
    heads, nxt = [], 32
    for i, l in enumerate(lines):
        m = GROUP_HEAD.match(l.text)
        a = int(m.group(1)) if m else -1
        if a >= nxt and a <= 98 and (a - 32) % 3 == 0 and a - nxt <= 30:
            heads.append((i, a))
            nxt = a + 3
    first_group = heads[0][0] if heads else len(lines)
    p1p2 = option_runs(lines[:first_group])
    # Part 4 (71–100): mỗi bài nói mở đầu bằng "W-Br You've reached …" – mốc chắc hơn tiêu đề "77-79"
    p4_from = next((i for i, a in heads if a >= 71), None)
    if p4_from is not None:
        starts = [i for i in range(p4_from, len(lines))
                  if (tm := TAG.match(lines[i].text)) and len(tm.group(5).strip(' /')) > 10]
        if len(starts) == 10:
            heads = [h for h in heads if h[1] < 71] + [(i - 1, 71 + 3 * k) for k, i in enumerate(starts)]
    groups = {}
    for k, (i, a) in enumerate(heads):
        end = heads[k + 1][0] if k + 1 < len(heads) else len(lines)
        groups[a] = conversation(lines[i + 1:end], a, a + 2)
    # Dự phòng cho nhóm thiếu: transcript in lại câu hỏi kèm số ("71 What type …").
    # Lời thoại nhóm a nằm sau câu hỏi cuối của nhóm trước và trước dòng câu hỏi a.
    qline = {}
    for n in range(32, 101):
        for i in range(qline.get(n - 1, first_group), len(lines)):
            if re.match(rf'^{n}\.?\s+[A-Z][a-z]', lines[i].text) and len(lines[i].text) > 12:
                qline[n] = i
                break
    for a in range(32, 101, 3):
        if groups.get(a) or a not in qline:
            continue
        start = qline.get(a - 1, first_group)
        block = lines[start + 1:qline[a]]
        # bắt đầu từ dòng mở đầu lời thoại (ký hiệu giọng đọc hoặc "W/M …")
        first = next((k for k, l in enumerate(block)
                      if TAG.match(l.text) or (SPEAKER.match(l.text) and valid_en(l.text))), None)
        if first is not None:
            groups[a] = conversation(block[first:], a, a + 2)
    return p1p2, groups


def valid_en(t):
    return not JUNK.search(t) and ascii_ratio(t) > 0.95 and sum(c.isalpha() for c in t) >= 0.6 * len(t)


NUM_TAG = re.compile(r'^(\d{1,2})\s*(?:[MW][-–]|$)')


def option_runs(lines):
    """Chuỗi (A)→(B)→(C)(→D) = 1 câu Part 1/2. Trả {số câu: (stem, [đáp án])}.

    Gán số câu theo MỐC (dòng "10 W-Am / M-Au" hoặc "10" đứng trước chuỗi) chứ không đếm thứ tự,
    để 1 câu bị OCR hỏng không làm lệch mọi câu sau. Chuỗi hỏng (<3 đáp án) vẫn giữ chỗ.
    """
    runs, i = [], 0
    while i < len(lines):
        m = OPT.match(lines[i].text)
        if not (m and m.group(1) == 'A' and valid_en(m.group(2))):
            i += 1
            continue
        start, opts, cur, j = i, {'A': m.group(2)}, 'A', i + 1
        while j < len(lines):
            t = lines[j].text.lstrip('. ')
            om = OPT.match(t)
            if om and om.group(1) == chr(ord(cur) + 1) and valid_en(om.group(2)):
                cur = om.group(1)
                opts[cur] = om.group(2)
            elif not re.search(r'[.?!]$', opts[cur]) and re.match(r'^[a-z]', t) and valid_en(t):
                opts[cur] += ' ' + t
            elif om and om.group(1) == chr(ord(cur) + 1):
                cur = om.group(1)  # đáp án OCR hỏng: giữ chỗ, không làm vỡ chuỗi
                opts[cur] = ''
            else:
                break
            j += 1
        stem, num = [], None
        for ln in reversed(lines[max(0, start - 5):start]):
            nm = NUM_TAG.match(ln.text)
            if nm:
                num = int(nm.group(1))
                break
            if TAG.match(ln.text) or OPT.match(ln.text) or not valid_en(ln.text):
                if stem:
                    continue
                continue
            stem.insert(0, ln.text)
        runs.append({'num': num, 'stem': clean(' '.join(stem)),
                     'opts': [clean(opts[c]) for c in 'ABCD' if c in opts],
                     'four': 'D' in opts})
        i = j
    # Part 1 = các chuỗi 4 đáp án đầu tiên (tối đa 6), Part 2 = phần còn lại
    p1 = [r for r in runs if r['four']][:6]
    p2 = [r for r in runs if r not in p1]
    out = {}
    for group, first in ((p1, 1), (p2, 7)):
        known = [(k, r['num']) for k, r in enumerate(group) if r['num'] and first <= r['num'] < first + (6 if first == 1 else 25)]
        anchors = [(-1, first - 1)] + known + [(len(group), first + (6 if first == 1 else 25))]
        for (ka, na), (kb, nb) in zip(anchors, anchors[1:]):
            if kb - ka == nb - na:  # số chuỗi giữa 2 mốc khớp số câu → gán tuần tự an toàn
                for off, k in enumerate(range(ka + 1, kb)):
                    out[na + 1 + off] = group[k]
            for k in range(ka + 1, kb):
                if group[k]['num'] and first <= group[k]['num']:
                    out[group[k]['num']] = group[k]
            if kb < len(group):
                out[nb] = group[kb]
    assigned = {n: (r['stem'], r['opts']) for n, r in out.items() if all(r['opts'])}
    assigned['_all'] = [(r['stem'], r['opts']) for r in runs if all(r['opts'])]
    return assigned


def option_block(block, count):
    """Lấy (A)…(D) liên tiếp + câu hỏi đứng trước (Part 2) từ 1 khối transcript."""
    stem, opts, cur = [], {}, None
    for ln in block:
        om = OPT.match(ln.text)
        if om and om.group(1) not in opts and (not opts or om.group(1) == chr(ord(max(opts)) + 1)):
            cur = om.group(1)
            opts[cur] = om.group(2)
            if len(opts) == count and re.search(r'[.?!]$', opts[cur]):
                break
            continue
        if cur is None:
            if not opts and re.match(r'^[A-Z"\'(]', ln.text) and ascii_ratio(ln.text) > 0.95:
                stem.append(ln.text)
            continue
        if len(opts) <= count and not re.search(r'[.?!]$', opts[cur]) and re.match(r'^[a-z]', ln.text):
            opts[cur] += ' ' + ln.text
        elif len(opts) == count:
            break
    return clean(' '.join(stem)), [clean(opts[c]) for c in 'ABCD'[:count] if c in opts]


def _norm(s):
    return re.sub(r'[^a-z0-9 ]', '', re.sub(r'\s+', ' ', s.lower().replace('’', "'"))).strip()


def align_by_explanations(p1p2, explanations):
    """Giải thích (đã đối chiếu tay với OCR gốc + đáp án) trích nguyên văn câu tiếng Anh.
    Transcript câu n phải chứa câu trích đó; nếu không, tìm khối khác chứa nó, không có thì bỏ trống."""
    pool = p1p2.get('_all', [])
    fixed = {}
    for n in range(1, 32):
        raw = re.findall(r"'([^']+)'", explanations.get(str(n), '').replace('’', "'"))
        quotes = [_norm(q)[:25] for q in raw if all(ord(c) < 128 for c in q) and len(q) >= 8]
        cur = p1p2.get(n)
        text = lambda r: _norm(r[0] + ' ' + ' '.join(r[1]))
        if not quotes:
            if cur:
                fixed[n] = cur
            continue
        if cur and any(q in text(cur) for q in quotes):
            fixed[n] = cur
            continue
        want = 4 if n <= 6 else 3
        match = [r for r in pool if len(r[1]) == want and any(q in text(r) for q in quotes)]
        if len(match) == 1:
            fixed[n] = match[0]
    return fixed


def ascii_ratio(s):
    return sum(c.isascii() for c in s) / max(1, len(s))


def conversation(block, lo, hi):
    out = []
    for ln in block:
        t = ln.text
        tm = TAG.match(t)
        if tm:  # Part 4: "W-Br You've reached ..." – tag dính câu đầu
            t = tm.group(5).strip(' /')
            t = re.sub(r'^([MW][-–]\s?(Am|Br|Cn|Au)\s*/?\s*)+', '', t)
            if not t:
                continue
        if JUNK.search(t) or sum(c.isalpha() for c in t) < 0.6 * len(t):
            continue
        if Q_START.match(t) and lo <= int(Q_START.match(t).group(1)) <= hi and len(t) > 8 and out:
            break  # tới phần câu hỏi
        if re.match(rf'^({lo}|{lo + 1}|{hi})\s+(What|Who|Why|Where|When|How|Which|Look)', t):
            break
        if ascii_ratio(t) < 0.97 or re.search(r'Paraphrasing|\bTEST\b', t):
            continue
        t = re.sub(r'\b\d{2,3}\s*(?=[A-Z])', '', t)        # số gợi ý dính chữ: "33So" → "So"
        t = re.sub(r'(?<=\s)\d{2,3}(?=\s)', '', t)         # số gợi ý đứng giữa câu
        t = t.replace("l'lI", "I'll").replace("l'll", "I'll").replace(" l'm", " I'm").replace("l've", "I've")
        sm = SPEAKER.match(t)
        if sm and sm.group(1).upper() in 'MW' and len(sm.group(2)) > 1:
            out.append(f'{sm.group(1).upper()}: {sm.group(2)}')
        elif out and re.match(r'^[a-z0-9"\'(,—-]|^[A-Z][a-z]', t):
            out[-1] += ' ' + t
        elif not out and re.match(r'^[A-Z]', t) and len(t) > 25:
            out.append(t)  # Part 4: bài nói 1 người, không có ký hiệu M/W
    return '\n'.join(clean(x) for x in out)


# ------------------------------------------------------------------ build
def build(test, keys):
    out_dir = os.path.join(C, 'tests', f'ets2026_test{test:02d}')
    os.makedirs(out_dir, exist_ok=True)
    warn = []
    lc_pages = set(range(14 * (test - 1) + 1, 14 * test + 1))
    rc_pages = set(range(30 * (test - 1) + 1, 30 * test + 1))
    key = {int(k): v for k, v in keys[str(test)].items()}
    groups = []

    p1p2, convo = parse_transcript(test)
    import glob
    explanations = {}
    for ex_path in sorted(glob.glob(os.path.join(WORK, 'explanations', f'test{test:02d}*.json'))):
        explanations.update(json.load(open(ex_path)))
    p1p2 = align_by_explanations(p1p2, explanations)

    # ----- Part 1 (1–6): ảnh trên trang 3–5 của đề
    base = 14 * (test - 1)
    photo_rects = []
    for pg in (base + 3, base + 4, base + 5):
        photo_rects += [(pg, r) for r in photos(pg)]
    if len(photo_rects) != 6:
        warn.append(f'Part 1: dò được {len(photo_rects)}/6 ảnh')
    for n in range(1, 7):
        g = {'part': 1, 'questions': [{'number': n, 'answer': key.get(n, '?')}]}
        if n <= len(photo_rects):
            pg, (x, y, w, h) = photo_rects[n - 1]
            name = f'p1_{n}.jpg'
            crop(LC_PDF, pg, x - 0.01, y - 0.01, w + 0.02, h + 0.02, os.path.join(out_dir, name), 160)
            g['image'] = name
        g['audio'] = audio(test, f'{n:02d}', out_dir)
        if n in p1p2:
            _, opts = p1p2[n]
            if len(opts) == 4:
                g['transcript'] = '\n'.join(f'({c}) {o}' for c, o in zip('ABCD', opts))
            else:
                warn.append(f'Câu {n}: transcript thiếu đáp án ({len(opts)}/4)')
        groups.append(g)

    # ----- Part 2 (7–31)
    for n in range(7, 32):
        g = {'part': 2, 'questions': [{'number': n, 'answer': key.get(n, '?')}],
             'audio': audio(test, f'{n:02d}', out_dir)}
        if n in p1p2:
            stem, opts = p1p2[n]
            if stem and len(opts) == 3:
                g['transcript'] = f'{stem}\n' + '\n'.join(f'({c}) {o}' for c, o in zip('ABC', opts))
            else:
                warn.append(f'Câu {n}: transcript chưa đủ (stem={bool(stem)}, {len(opts)}/3)')
        groups.append(g)

    # ----- Part 3/4 (32–100): câu hỏi từ sách LC, lời thoại từ transcript
    lc = load_tsv('lc.tsv', lc_pages)
    lq = parse_questions(lc, 32, 100)
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
        g = {'part': part, 'questions': qs, 'audio': audio(test, f'{start}-{start + 2}', out_dir)}
        if convo.get(start):
            g['transcript'] = convo[start]
        else:
            warn.append(f'Nhóm {start}-{start + 2}: chưa lấy được transcript')
        if any('graphic' in (q.get('content') or '').lower() for q in qs) and lq.get(start):
            g['image'] = graphic(lc, lq[start]['first'], LC_PDF, out_dir, f'g{start}.jpg', warn)
        groups.append(g)

    # ----- Part 5 (101–130)
    # Ưu tiên bản OCR 300 dpi (ít gộp dòng hơn) nếu đã có
    rc_name = 'rc300.tsv' if os.path.exists(os.path.join(WORK, 'rc300.done')) else 'rc.tsv'
    rc = load_tsv(rc_name, rc_pages)
    rq = parse_questions(rc, 101, 130)
    for n in range(101, 131):
        q = rq.get(n)
        if not q or len(q['options']) != 4:
            warn.append(f'Câu {n}: OCR thiếu ({0 if not q else len(q["options"])}/4 đáp án)')
        groups.append({'part': 5, 'questions': [{'number': n, 'answer': key.get(n, '?'),
                                                 'content': q and norm_blank(q['content']),
                                                 'options': q['options'] if q else []}]})

    # ----- Part 6 (131–146) + Part 7 (147–200): nhóm theo "Questions a-b refer to ..."
    headers = []
    for i, ln in enumerate(rc):
        m = re.match(r'^Questions?\s+(\d{3})\s*[-–]\s*(\d{3})\s+refer', ln.text, re.I)
        if m:
            headers.append((i, int(m.group(1)), int(m.group(2))))
    q6 = parse_questions(rc, 131, 146, need_stem=False)
    q7 = parse_questions(rc, 147, 200)
    found = {(a, b) for _, a, b in headers}
    for k, (i, a, b) in enumerate(headers):
        part = 6 if a < 147 else 7
        qmap = q6 if part == 6 else q7
        first = qmap.get(a)
        passage_lines = region_lines(rc, rc[i], first['first'] if first else None,
                                     rc[headers[k + 1][0]] if k + 1 < len(headers) else None)
        text = join_paragraphs(passage_lines)
        if part == 6:
            text = re.sub(r'\b(1[34]\d)\.?(?=\s|$)', lambda m: f'---({m.group(1)})---'
                          if a <= int(m.group(1)) <= b else m.group(0), text)
        qs = []
        for n in range(a, b + 1):
            q = qmap.get(n)
            if not q or len(q['options']) != 4:
                warn.append(f'Câu {n}: OCR thiếu ({0 if not q else len(q["options"])}/4 đáp án)')
            qs.append({'number': n, 'answer': key.get(n, '?'), 'content': q and q['content'],
                       'options': q['options'] if q else []})
        g = {'part': part, 'passage': text, 'questions': qs}
        if part == 7 and passage_lines:
            g['image'] = passage_image(rc[i], passage_lines, out_dir, f'r{a}.jpg')
        groups.append(g)
    for a, b in [(131, 134), (135, 138), (139, 142), (143, 146)]:
        if (a, b) not in found:
            warn.append(f'Không tìm thấy tiêu đề nhóm Part 6 {a}-{b}')

    # ----- sửa tay (content/raw/ets2026/overrides.json): {"test": {"câu": {"content", "options", "passage"}}}
    ov_path = os.path.join(WORK, 'overrides.json')
    overrides = json.load(open(ov_path)).get(str(test), {}) if os.path.exists(ov_path) else {}
    for g in groups:
        for q in g['questions']:
            fix = overrides.get(str(q['number']))
            if fix:
                q.update({k: v for k, v in fix.items() if k in ('content', 'options')})
                if 'passage' in fix:
                    g['passage'] = fix['passage']
                warn[:] = [w for w in warn if not w.startswith(f'Câu {q["number"]}:')]

    # ----- giải thích tiếng Việt: content/raw/ets2026/explanations/testNN.json {"câu": "…"}
    for g in groups:
        for q in g['questions']:
            if explanations.get(str(q['number'])):
                q['explanation'] = explanations[str(q['number'])]

    # ----- kiểm tra
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
        'title': f'ETS 2026 – Test {test}',
        'source': 'ETS 2026',
        'description': 'Chuyển từ sách scan bằng OCR. Đoạn văn Part 7 có kèm ảnh gốc để đối chiếu.',
        'groups': groups,
    }
    with open(os.path.join(out_dir, 'test.json'), 'w', encoding='utf-8') as f:
        json.dump(test_json, f, ensure_ascii=False, indent=1)
    size = sum(os.path.getsize(os.path.join(out_dir, x)) for x in os.listdir(out_dir)) / 1e6
    print(f'Test {test}: {len(groups)} nhóm, {len(numbers)} câu, {size:.1f} MB, {len(warn)} cảnh báo',
          file=sys.stderr)
    for w in warn:
        print(f'  ⚠ {w}', file=sys.stderr)
    return warn


def region_lines(lines, header, first_q, next_header):
    """Dòng chưa dùng nằm giữa tiêu đề nhóm và câu hỏi đầu (theo trang + vị trí dọc), sắp trên→dưới."""
    end = first_q or next_header
    def after(l, ref):
        return (l.page, l.y) > (ref.page, ref.y + 0.002)
    def before(l, ref):
        return ref is None or (l.page, l.y) < (ref.page, ref.y - 0.002)
    out = [l for l in lines if not l.used and after(l, header) and before(l, end)
           and not re.match(r'^Questions?\s+\d{3}', l.text)]
    return sorted(out, key=lambda l: (l.page, l.y, l.x))


def graphic(lines, first_q, pdf, out_dir, name, warn):
    """Biểu đồ của nhóm 'Look at the graphic': các dòng chưa dùng ngay trước câu đầu, cùng trang/cột."""
    idx = lines.index(first_q)
    region = []
    for ln in reversed(lines[:idx]):
        if ln.used or ln.page != first_q.page:
            break
        region.append(ln)
    if not region:
        crop(pdf, first_q.page, 0.05, 0.03, 0.9, 0.94, os.path.join(out_dir, name), 130)
        warn.append(f'{name}: không định vị được biểu đồ, dùng cả trang')
        return name
    # Hình vẽ không có chữ (áo trên kệ, logo…) nằm phía trên dòng chữ đầu tiên của biểu đồ:
    # nới lên tối đa 0,12 nhưng không vượt dòng đã dùng gần nhất (câu hỏi trước) cùng cột.
    above = [l.y for l in lines[:idx] if l.used and l.page == first_q.page and l.col == first_q.col
             and l.y < min(r.y for r in region)]
    floor = (max(above) + 0.02) if above else 0.03
    top = max(floor, min(l.y for l in region) - 0.12)
    col_x = {'L': (0.06, 0.47), 'R': (0.50, 0.45), 'F': (0.06, 0.88)}[first_q.col]
    crop(pdf, first_q.page, col_x[0], top, col_x[1], first_q.y - top - 0.004, os.path.join(out_dir, name), 170)
    return name


def passage_image(header, plines, out_dir, name):
    """Ảnh scan đoạn văn Part 7 (từ tiêu đề tới hết đoạn); nhiều trang thì ghép dọc."""
    pages = defaultdict(list)
    for l in [header] + plines:
        pages[l.page].append(l)
    specs = []
    for p in sorted(pages):
        ys = [l.y for l in pages[p]]
        top, bottom = max(0.02, min(ys) - 0.01), min(0.97, max(ys) + 0.035)
        specs.append(f'{p}:0.05:{top:.4f}:0.90:{bottom - top:.4f}')
    run(*TOOL, 'cropstack', RC_PDF, os.path.join(out_dir, name), '150', *specs)
    return name


if __name__ == '__main__':
    arg = sys.argv[1] if len(sys.argv) > 1 else '1'
    a, _, b = arg.partition('-')
    keys = json.load(open(os.path.join(WORK, 'keys.json')))
    total = 0
    for t in range(int(a), int(b or a) + 1):
        total += len(build(t, keys))
    print(f'Tổng cảnh báo: {total}', file=sys.stderr)
    if SPELL_LOG:
        from collections import Counter
        top = Counter(SPELL_LOG).most_common()
        print(f'Tự sửa chính tả {len(SPELL_LOG)} lần: ' + ', '.join(f'{a}→{b}' for (a, b), _ in top),
              file=sys.stderr)
