#!/usr/bin/env python3
"""Cắt audio theo Part (Test_NN-Part1..4.mp3) thành file từng câu / nhóm như các đề khác của bộ ETS 2024.

Mỗi file Part bắt đầu ngay ở câu đầu (không có lời hướng dẫn). Sau mỗi câu Part 1/2 là khoảng lặng trả lời ~5s;
Part 3/4 mỗi câu hỏi đọc xong có khoảng lặng ~8s → cứ 3 khoảng lặng dài là hết 1 nhóm.
Cắt ở cuối khoảng lặng (giữ phần lặng ở cuối đoạn trước, như file cắt sẵn).

  python3 tool/ets2024/split_parts.py 3 4      # → content/raw/ets2024/audio_cut/Test_03/Test_03-01.m4a …
"""
import array
import os
import subprocess
import sys
import tempfile
import wave

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
SRC = os.path.join(ROOT, 'content', 'ETS2024')
OUT = os.path.join(ROOT, 'content', 'raw', 'ets2024', 'audio_cut')
RATE = 16000
FRAME = 0.02  # giây / khung đo năng lượng

# Part → (tên file đích theo thứ tự, số khoảng lặng dài cần tìm, mỗi bao nhiêu khoảng lặng thì cắt)
PLAN = {
    1: ([f'{n:02d}' for n in range(1, 7)], 1),
    2: ([f'{n:02d}' for n in range(7, 32)], 1),
    3: ([f'{n}-{n + 2}' for n in range(32, 71, 3)], 3),
    4: ([f'{n}-{n + 2}' for n in range(71, 101, 3)], 3),
}


def decode(mp3, tmp):
    wav = os.path.join(tmp, 'pcm.wav')
    subprocess.run(['afconvert', '-f', 'WAVE', '-d', f'LEI16@{RATE}', '-c', '1', mp3, wav], check=True)
    with wave.open(wav) as w:
        return array.array('h', w.readframes(w.getnframes()))


def silences(pcm):
    """[(bắt đầu, kết thúc) giây] các đoạn lặng ≥ 0.3s."""
    n = int(RATE * FRAME)
    energy = []
    for i in range(0, len(pcm) - n, n):
        chunk = pcm[i:i + n]
        energy.append(sum(abs(x) for x in chunk) / n)
    if not energy:
        return []
    loud = sorted(energy)[int(len(energy) * 0.95)]
    thr = max(loud * 0.04, 40)
    out, start = [], None
    for i, e in enumerate(energy + [thr * 10]):
        if e < thr and start is None:
            start = i
        elif e >= thr and start is not None:
            if (i - start) * FRAME >= 0.3:
                out.append((start * FRAME, i * FRAME))
            start = None
    return out


def cut_points(sil, total, names, per):
    inner = [x for x in sil if x[1] < total - 0.5]  # bỏ khoảng lặng ở đuôi file
    if per == 1:
        # Part 1/2: khoảng lặng trả lời ~5s sau mỗi câu. Đôi khi có thêm 1 quãng nghỉ dài ngay sau lời đọc
        # "Number N." – 2 khoảng lặng dài cách nhau < 8s thì chỉ giữ cái đầu (ranh giới thật).
        longs = []
        for a, b in (x for x in inner if x[1] - x[0] >= 3.5):
            if longs and a - longs[-1][1] < 8:
                continue
            longs.append((a, b))
        # Một ranh giới dư ở cuối = đuôi file có vài giây lời của phần sau → cắt bỏ đuôi đó.
        if len(longs) == len(names) and total - longs[-1][1] < 10:
            return [b - 0.25 for _, b in longs]
        if len(longs) != len(names) - 1:
            raise SystemExit(f'Part 1/2: tìm được {len(longs)} ranh giới, cần {len(names) - 1}')
        return [b - 0.25 for _, b in longs]
    need = len(names) * per - 1  # Part 3/4: 3 khoảng lặng dài mỗi nhóm, trừ khoảng cuối file
    longest = sorted(sorted(inner, key=lambda x: x[1] - x[0], reverse=True)[:need])
    rest = sorted((x[1] - x[0] for x in inner), reverse=True)
    if len(longest) < need or (len(rest) > need and rest[need - 1] < rest[need] * 1.3):
        raise SystemExit(f'Part 3/4: khoảng lặng không tách bạch (cần {need})')
    ends = [x[1] for x in longest]
    return [ends[i] - 0.25 for i in range(per - 1, len(ends), per)]


def main():
    for test in [int(a) for a in sys.argv[1:]]:
        tag = f'Test_{test:02d}'
        folder = next(os.path.join(SRC, d, tag) for d in os.listdir(SRC) if os.path.isdir(os.path.join(SRC, d, tag)))
        dest = os.path.join(OUT, tag)
        os.makedirs(dest, exist_ok=True)
        for part, (names, per) in PLAN.items():
            src = os.path.join(folder, f'{tag}-Part{part}.mp3')
            with tempfile.TemporaryDirectory() as tmp:
                pcm = decode(src, tmp)
                total = len(pcm) / RATE
                cuts = cut_points(silences(pcm), total, names, per)
                bounds = [0.0, *cuts, total][: len(names) + 1]  # bỏ đuôi thừa (nếu có)
                lens = []
                for name, a, b in zip(names, bounds, bounds[1:]):
                    seg = os.path.join(tmp, 'seg.wav')
                    with wave.open(seg, 'wb') as w:
                        w.setnchannels(1)
                        w.setsampwidth(2)
                        w.setframerate(RATE)
                        w.writeframes(pcm[int(a * RATE):int(b * RATE)].tobytes())
                    out = os.path.join(dest, f'{tag}-{name}.m4a')
                    subprocess.run(['afconvert', '-f', 'm4af', '-d', 'aac', '-b', '48000', seg, out], check=True)
                    lens.append(b - a)
                print(f'{tag} Part {part}: {len(names)} đoạn · {min(lens):.1f}–{max(lens):.1f}s')


if __name__ == '__main__':
    main()
