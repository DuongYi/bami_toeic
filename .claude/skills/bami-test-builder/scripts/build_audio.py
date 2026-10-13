#!/usr/bin/env python3
"""Tạo audio Part 1–4 từ transcript bằng giọng macOS `say` (Mỹ / Anh / Úc), giống cách đọc đề ETS:
lời dẫn "Number 7." / "Questions 32 through 34 refer to…", đọc câu hỏi Part 3/4 sau bài nghe, có khoảng lặng trả lời.
Ưu tiên giọng Premium / Enhanced (tải trong System Settings → Accessibility → Spoken Content → Manage Voices);
chỉ khi máy chưa có mới dùng giọng thường. Chuẩn hoá âm lượng từng câu, xuất AAC 44,1 kHz 64 kbps (.m4a).
Chỉ tạo lại file khi kịch bản hoặc ENGINE đổi (manifest .audio_manifest.json).

  python3 build_audio.py content/tests/<id> [--force] [--only 7,32] [--gap 5] [--rate 165] [--list-voices]
"""
import argparse
import array
import hashlib
import math
import json
import random
import re
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from _common import SPEAKER, load, save, split_listening_transcript, test_dir  # noqa: E402

# Đổi khi cách dựng audio thay đổi → mọi file được tạo lại (manifest lưu hash kèm ENGINE).
ENGINE = 'say-hq-3'
RATE = 165          # từ/phút – đề thật đọc chậm, rõ
# Khoảng nghỉ (giây), gần với audio đề ETS: tách rõ từng phương án để người nghe kịp xử lý.
GAP_OPTION_P1 = 1.8   # giữa (A) (B) (C) (D) Part 1
GAP_AFTER_Q_P2 = 1.5  # sau câu hỏi Part 2, trước (A)
GAP_OPTION_P2 = 1.6   # giữa các phương án Part 2
GAP_TURN = 0.7        # giữa các lượt thoại Part 3 / câu Part 4
GAP_INTRO = 1.5       # sau lời dẫn "Questions … refer to …"
SAMPLE = 'LEI16@24000'
TARGET_RMS = 3000   # mức âm lượng chung của mọi câu (int16)

# Giới tính theo tên giọng tiếng Anh của macOS (say -v '?' không ghi giới tính).
FEMALE_NAMES = {'Ava', 'Zoe', 'Allison', 'Samantha', 'Susan', 'Joelle', 'Noelle', 'Serena', 'Kate', 'Stephanie',
                'Karen', 'Matilda', 'Catherine', 'Moira', 'Fiona', 'Tessa', 'Veena', 'Isha', 'Nicky', 'Martha'}
MALE_NAMES = {'Evan', 'Nathan', 'Tom', 'Alex', 'Aaron', 'Jamie', 'Daniel', 'Oliver', 'Arthur', 'Lee', 'Gordon',
              'Rishi', 'Aman', 'Fred', 'Malcolm'}
# Bộ giọng tổng hợp cũ (Eloquence) nghe rè, robot – chỉ dùng khi không còn gì khác.
LOW_QUALITY = {'Eddy', 'Flo', 'Reed', 'Rocko', 'Sandy', 'Shelley', 'Grandma', 'Grandpa', 'Fred'}
ACCENTS = ('en_US', 'en_GB', 'en_AU', 'en_CA', 'en_IE')


def available_voices():
    """{tên giọng: (giới tính, locale, điểm chất lượng)} của các giọng tiếng Anh."""
    out = subprocess.run(['say', '-v', '?'], capture_output=True, text=True).stdout
    voices = {}
    for line in out.splitlines():
        m = re.match(r'^(.*?)\s+([a-z]{2,3}_[A-Z0-9]{2,3})\s+#', line)
        if not m or m.group(2) not in ACCENTS:
            continue
        name = m.group(1)
        base = name.split(' (')[0]
        gender = 'f' if base in FEMALE_NAMES else 'm' if base in MALE_NAMES else None
        if gender is None:
            continue
        quality = 3 if 'Premium' in name else 2 if 'Enhanced' in name else 0 if base in LOW_QUALITY else 1
        voices[name] = (gender, m.group(2), quality)
    return voices


def pools(voices):
    """Giọng nam / nữ tốt nhất hiện có: mọi giọng Premium + Enhanced (thêm giọng vùng miền), không có thì mức cao nhất."""
    out = {}
    for g in ('m', 'f'):
        mine = {n: v for n, v in voices.items() if v[0] == g}
        best = max((v[2] for v in mine.values()), default=None)
        floor = min(best, 2) if best is not None else None
        chosen = {}
        for n, v in mine.items():  # mỗi giọng (Ava, Zoe…) chỉ giữ bản tốt nhất: Premium > Enhanced
            base = n.split(' (')[0]
            if floor is not None and v[2] >= floor and v[2] > chosen.get(base, (None, -1))[1]:
                chosen[base] = (n, v[2])
        out[g] = sorted(n for n, _ in chosen.values())
    return out


def script_for(g, gap=5.0):
    """Kịch bản của 1 nhóm: [(vai, câu) | ('pause', giây)]. Vai: narrator / m / w / m1 / w2 / speaker."""
    part = g['part']
    qs = g['questions']
    n0, n1 = qs[0]['number'], qs[-1]['number']
    s = []
    if part == 1:
        _, opts = split_listening_transcript(g.get('transcript'))
        s += [('narrator', f'Number {n0}.'), ('pause', 0.6),
              ('narrator', f'Look at the picture marked number {n0} in your test book.'), ('pause', GAP_INTRO)]
        for c in sorted(opts):
            s += [('speaker', f'{c}. {opts[c]}'), ('pause', GAP_OPTION_P1)]
        s.append(('pause', gap))
    elif part == 2:
        head, opts = split_listening_transcript(g.get('transcript'))
        s += [('narrator', f'Number {n0}.'), ('pause', 0.6), ('asker', head), ('pause', GAP_AFTER_Q_P2)]
        for c in sorted(opts):
            s += [('responder', f'{c}. {opts[c]}'), ('pause', GAP_OPTION_P2)]
        s.append(('pause', gap))
    else:
        lines = [l.strip() for l in (g.get('transcript') or '').splitlines() if l.strip()]
        kind = 'conversation' if part == 3 else 'talk'
        speakers = {m.group(1).upper() for l in lines if (m := SPEAKER.match(l))}
        intro = f'Questions {n0} through {n1} refer to the following {kind}'
        if part == 3 and len(speakers) >= 3:
            intro += ' with three speakers'
        if g.get('image'):
            intro += ' and graphic'
        s += [('narrator', intro + '.'), ('pause', GAP_INTRO)]
        for l in lines:
            m = SPEAKER.match(l)
            s += [(m.group(1).lower(), m.group(2)) if m else ('speaker', l), ('pause', GAP_TURN)]
        s.append(('pause', 1.0))
        for q in qs:
            content = q.get('content') or ''
            s += [('narrator', f'Number {q["number"]}. {content}'),
                  ('pause', gap + (3 if content.lower().startswith('look at the graphic') else 0))]
    return s


def cast(g, title, voices):
    """Gán giọng cho các vai, ổn định theo tên đề + số câu, khác giọng giữa người nói."""
    rng = random.Random(f'{title}:{g["questions"][0]["number"]}')
    p = pools(voices)
    if not (p['m'] and p['f']):
        sys.exit('Thiếu giọng tiếng Anh nam/nữ – System Settings → Accessibility → Spoken Content → Manage Voices.')
    male, female = p['m'][:], p['f'][:]
    # Người dẫn cố định cả đề (giọng Mỹ nếu có), như đề ETS.
    us = [n for n in male if voices[n][1] == 'en_US'] or male
    narrator = sorted(us)[0]
    rng.shuffle(male)
    rng.shuffle(female)
    male = [v for v in male if v != narrator] or male
    first_female = rng.random() < 0.5
    roles = {'narrator': narrator, 'm': male[0], 'm1': male[0], 'm2': male[1 % len(male)],
             'w': female[0], 'w1': female[0], 'w2': female[1 % len(female)]}
    roles['speaker'] = female[0] if first_female else male[0]
    roles['asker'] = roles['speaker']
    roles['responder'] = male[0] if first_female else female[0]
    return roles


def _normalize(pcm):
    """Đưa 1 câu (int16 mono) về cùng mức RMS, không để vượt đỉnh."""
    a = array.array('h', pcm)
    if not a:
        return pcm
    rms = math.sqrt(sum(x * x for x in a) / len(a)) or 1
    peak = max(abs(x) for x in a) or 1
    gain = min(TARGET_RMS / rms, 30000 / peak)
    return array.array('h', (int(x * gain) for x in a)).tobytes()


def audio_key(g):
    """Hash để biết file audio đã khớp kịch bản + cách dựng hiện tại (validate_test.py dùng chung)."""
    return hashlib.sha1(json.dumps({'engine': ENGINE, 'script': script_for(g)}, ensure_ascii=False).encode()).hexdigest()


def render(script, roles, out, rate, tmp):
    frames, params = [], None
    for i, (role, text) in enumerate(script):
        if role == 'pause':
            frames.append(('pause', text))
            continue
        seg = Path(tmp) / f'{i}.wav'
        subprocess.run(['say', '-v', roles.get(role, roles['speaker']), '-r', str(rate),
                        f'--data-format={SAMPLE}', '--file-format=WAVE', '-o', str(seg), text], check=True)
        with wave.open(str(seg)) as w:
            params = params or w.getparams()
            frames.append(('audio', _normalize(w.readframes(w.getnframes()))))
    wav = Path(tmp) / 'all.wav'
    with wave.open(str(wav), 'wb') as w:
        w.setparams(params)
        silence = b'\x00' * params.sampwidth * params.nchannels
        for kind, v in frames:
            w.writeframes(silence * int(params.framerate * v) if kind == 'pause' else v)
    subprocess.run(['afconvert', '-f', 'm4af', '-d', 'aac@44100', '-b', '64000', '--src-complexity', 'bats',
                    str(wav), str(out)], check=True)


def default_name(g):
    qs = g['questions']
    a, b = qs[0]['number'], qs[-1]['number']
    return f'p{g["part"]}_q{a}.m4a' if a == b else f'p{g["part"]}_q{a}-{b}.m4a'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dir', nargs='?')
    ap.add_argument('--force', action='store_true')
    ap.add_argument('--only', help='số câu đầu nhóm, cách nhau dấu phẩy')
    ap.add_argument('--gap', type=float, default=5.0, help='giây lặng để trả lời (đề thật: 5s Part 1/2, 8s Part 3/4)')
    ap.add_argument('--rate', type=int, default=RATE)
    ap.add_argument('--list-voices', action='store_true')
    a = ap.parse_args()
    voices = available_voices()
    if a.list_voices:
        p = pools(voices)
        for g, label in (('m', 'Nam'), ('f', 'Nữ ')):
            q = max((voices[n][2] for n in p[g]), default=0)
            print(f'{label} ({["robot", "thường", "Enhanced", "Premium"][q]}):', [f'{n} [{voices[n][1]}]' for n in p[g]])
        return
    if not a.dir:
        sys.exit(__doc__)
    d = test_dir(a.dir)
    data = load(d / 'test.json')
    mf = d / '.audio_manifest.json'
    manifest = json.loads(mf.read_text()) if mf.exists() else {}
    only = {int(x) for x in a.only.split(',')} if a.only else None
    changed_json = made = 0
    for g in data['groups']:
        if g['part'] > 4:
            continue
        if only and g['questions'][0]['number'] not in only:
            continue
        if not g.get('audio') or g['audio'].startswith('http'):
            if g.get('audio', '').startswith('http'):
                continue
            g['audio'] = default_name(g)
            changed_json += 1
        script = script_for(g, a.gap)
        h = audio_key(g)
        out = d / g['audio']
        if out.exists() and manifest.get(g['audio']) == h and not a.force:
            continue
        with tempfile.TemporaryDirectory() as tmp:
            render(script, cast(g, data['title'], voices), out, a.rate, tmp)
        manifest[g['audio']] = h
        made += 1
        print(f'  🔊 {g["audio"]}')
        mf.write_text(json.dumps(manifest, indent=2))
    if changed_json:
        save(d / 'test.json', data)
    print(f'✅ Tạo {made} file audio' + (f', đặt tên audio cho {changed_json} nhóm trong test.json' if changed_json else ''))


if __name__ == '__main__':
    main()
