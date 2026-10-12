#!/usr/bin/env python3
"""Tạo audio Part 1–4 từ transcript bằng giọng macOS `say` (Mỹ / Anh / Úc), giống cách đọc đề ETS:
lời dẫn "Number 7." / "Questions 32 through 34 refer to…", đọc câu hỏi Part 3/4 sau bài nghe, có khoảng lặng trả lời.
Xuất AAC 48 kbps (.m4a) bằng `afconvert`. Chỉ tạo lại file khi kịch bản đổi (manifest .audio_manifest.json).

  python3 build_audio.py content/tests/<id> [--force] [--only 7,32] [--gap 5] [--rate 165] [--list-voices]
"""
import argparse
import hashlib
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

NARRATOR = ['Reed (English (US))', 'Eddy (English (US))', 'Samantha']
MALE = ['Reed (English (US))', 'Eddy (English (US))', 'Rocko (English (US))', 'Daniel',
        'Reed (English (UK))', 'Eddy (English (UK))', 'Rocko (English (UK))', 'Aman', 'Rishi']
FEMALE = ['Samantha', 'Flo (English (US))', 'Shelley (English (US))', 'Sandy (English (US))', 'Karen',
          'Flo (English (UK))', 'Shelley (English (UK))', 'Sandy (English (UK))', 'Moira', 'Tessa']
RATE = 165          # từ/phút – đề thật đọc chậm, rõ
SAMPLE = 'LEI16@22050'


def available_voices():
    out = subprocess.run(['say', '-v', '?'], capture_output=True, text=True).stdout
    # Dòng dạng: "Eddy (English (US)) en_US    # Hello! …"
    return {m.group(1) for line in out.splitlines() if (m := re.match(r'^(.*?)\s+[a-z]{2,3}_[A-Z0-9]{2,3}\s+#', line))}


def script_for(g, gap=5.0):
    """Kịch bản của 1 nhóm: [(vai, câu) | ('pause', giây)]. Vai: narrator / m / w / m1 / w2 / speaker."""
    part = g['part']
    qs = g['questions']
    n0, n1 = qs[0]['number'], qs[-1]['number']
    s = []
    if part == 1:
        _, opts = split_listening_transcript(g.get('transcript'))
        s += [('narrator', f'Number {n0}.'), ('pause', 0.6),
              ('narrator', f'Look at the picture marked number {n0} in your test book.'), ('pause', 1.0)]
        for c in sorted(opts):
            s += [('speaker', f'{c}. {opts[c]}'), ('pause', 1.0)]
        s.append(('pause', gap))
    elif part == 2:
        head, opts = split_listening_transcript(g.get('transcript'))
        s += [('narrator', f'Number {n0}.'), ('pause', 0.6), ('asker', head), ('pause', 1.0)]
        for c in sorted(opts):
            s += [('responder', f'{c}. {opts[c]}'), ('pause', 0.8)]
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
        s += [('narrator', intro + '.'), ('pause', 1.2)]
        for l in lines:
            m = SPEAKER.match(l)
            s += [(m.group(1).lower(), m.group(2)) if m else ('speaker', l), ('pause', 0.5)]
        s.append(('pause', 1.0))
        for q in qs:
            content = q.get('content') or ''
            s += [('narrator', f'Number {q["number"]}. {content}'),
                  ('pause', gap + (3 if content.lower().startswith('look at the graphic') else 0))]
    return s


def cast(g, title, voices):
    """Gán giọng cho các vai, ổn định theo tên đề + số câu, khác giọng giữa người nói."""
    rng = random.Random(f'{title}:{g["questions"][0]["number"]}')
    male = [v for v in MALE if v in voices]
    female = [v for v in FEMALE if v in voices]
    narrator = next((v for v in NARRATOR if v in voices), None)
    if not (male and female and narrator):
        sys.exit('Thiếu giọng tiếng Anh của macOS – System Settings → Accessibility → Spoken Content → tải thêm giọng.')
    rng.shuffle(male)
    rng.shuffle(female)
    male = [v for v in male if v != narrator] or male
    female = [v for v in female if v != narrator] or female
    first_female = rng.random() < 0.5
    roles = {'narrator': narrator, 'm': male[0], 'm1': male[0], 'm2': male[1 % len(male)],
             'w': female[0], 'w1': female[0], 'w2': female[1 % len(female)]}
    roles['speaker'] = female[0] if first_female else male[0]
    roles['asker'] = roles['speaker']
    roles['responder'] = male[0] if first_female else female[0]
    return roles


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
            frames.append(('audio', w.readframes(w.getnframes())))
    wav = Path(tmp) / 'all.wav'
    with wave.open(str(wav), 'wb') as w:
        w.setparams(params)
        silence = b'\x00' * params.sampwidth * params.nchannels
        for kind, v in frames:
            w.writeframes(silence * int(params.framerate * v) if kind == 'pause' else v)
    subprocess.run(['afconvert', '-f', 'm4af', '-d', 'aac', '-b', '48000', str(wav), str(out)], check=True)


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
        print('Nam:', [v for v in MALE if v in voices])
        print('Nữ :', [v for v in FEMALE if v in voices])
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
        h = hashlib.sha1(json.dumps(script_for(g), ensure_ascii=False).encode()).hexdigest()
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
