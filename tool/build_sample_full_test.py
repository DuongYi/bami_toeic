#!/usr/bin/env python3
"""Dựng đề mẫu đủ 7 Part (nội dung tự soạn) để test app.

Tạo trong content/tests/sample_full_test/:
  - test.json           (định dạng của tool/import_test.dart)
  - *.m4a               audio Part 1–4 (giọng đọc macOS `say`, nhiều giọng cho hội thoại)
  - p1_q1.png, p1_q2.png ảnh Part 1 (vẽ SVG → PNG bằng qlmanage + sips)

Chỉ chạy được trên macOS (cần `say`, `afconvert`, `qlmanage`, `sips`).

    python3 tool/build_sample_full_test.py
    dart run tool/import_test.dart content/tests/sample_full_test --replace
"""
import json
import os
import shutil
import subprocess
import tempfile
import wave

OUT = os.path.join(os.path.dirname(__file__), '..', 'content', 'tests', 'sample_full_test')
RATE = 22050
VOICE = {'N': 'Samantha', 'W': 'Samantha', 'M': 'Daniel', 'A': 'Karen', 'R': 'Reed (English (US))'}
GAP_MS = 700  # khoảng lặng giữa các câu nói


# ---------------------------------------------------------------- audio
def _say_wav(text, voice, path):
    subprocess.run(
        ['say', '-v', voice, '-o', path, '--file-format=WAVE', f'--data-format=LEI16@{RATE}', text],
        check=True,
    )


def make_audio(lines, name, tmp):
    """lines: [(speaker, text)] → content/.../name.m4a (ghép nhiều giọng, chèn khoảng lặng)."""
    frames = b''
    silence = b'\x00\x00' * int(RATE * GAP_MS / 1000)
    for i, (spk, text) in enumerate(lines):
        part = os.path.join(tmp, f'{name}_{i}.wav')
        _say_wav(text, VOICE[spk], part)
        with wave.open(part) as w:
            frames += w.readframes(w.getnframes()) + silence
    wav = os.path.join(tmp, f'{name}.wav')
    with wave.open(wav, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(frames)
    out = os.path.join(OUT, f'{name}.m4a')
    subprocess.run(['afconvert', '-f', 'm4af', '-d', 'aac', '-b', '64000', wav, out], check=True)
    return f'{name}.m4a'


# ---------------------------------------------------------------- images
def make_image(svg, name, tmp):
    src = os.path.join(tmp, f'{name}.svg')
    with open(src, 'w') as f:
        f.write(svg)
    subprocess.run(['qlmanage', '-t', '-s', '800', '-o', tmp, src], check=True, capture_output=True)
    png = os.path.join(OUT, f'{name}.png')
    shutil.move(src + '.png', png)
    # qlmanage xuất khung vuông 800×800 → cắt giữa lấy 800×600
    subprocess.run(['sips', '--cropToHeightWidth', '600', '800', png], check=True, capture_output=True)
    return f'{name}.png'


SVG_DESK = '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800" viewBox="0 -100 800 800">
<rect x="0" y="-100" width="800" height="800" fill="#e8eef7"/>
<rect x="0" y="0" width="800" height="420" fill="#dfe8f5"/>
<rect x="520" y="40" width="200" height="150" rx="6" fill="#ffffff" stroke="#9aa9bf" stroke-width="6"/>
<line x1="620" y1="40" x2="620" y2="190" stroke="#9aa9bf" stroke-width="4"/>
<rect x="0" y="420" width="800" height="180" fill="#b98b5e"/>
<rect x="0" y="410" width="800" height="22" fill="#a0744a"/>
<rect x="250" y="250" width="270" height="165" rx="10" fill="#2f3a4a"/>
<rect x="265" y="264" width="240" height="138" rx="4" fill="#7fb2ff"/>
<polygon points="220,415 550,415 580,440 190,440" fill="#596579"/>
<rect x="600" y="345" width="60" height="70" rx="8" fill="#ffffff" stroke="#cfd6e0" stroke-width="4"/>
<path d="M660 360 q30 5 0 40" fill="none" stroke="#cfd6e0" stroke-width="8"/>
<rect x="90" y="350" width="70" height="65" rx="6" fill="#c0603a"/>
<ellipse cx="110" cy="320" rx="28" ry="45" fill="#3f9b5a"/>
<ellipse cx="145" cy="300" rx="25" ry="55" fill="#4fb36b"/>
<ellipse cx="125" cy="290" rx="18" ry="50" fill="#2f8a4b"/>
</svg>'''

SVG_BIKES = '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800" viewBox="0 -100 800 800">
<rect x="0" y="-100" width="800" height="800" fill="#cde6ff"/>
<rect x="0" y="380" width="800" height="220" fill="#b7b7b7"/>
<g stroke="#8a5a2b" stroke-width="10">
  <line x1="0" y1="250" x2="800" y2="250"/><line x1="0" y1="330" x2="800" y2="330"/>
  <line x1="40" y1="200" x2="40" y2="390"/><line x1="200" y1="200" x2="200" y2="390"/>
  <line x1="360" y1="200" x2="360" y2="390"/><line x1="520" y1="200" x2="520" y2="390"/>
  <line x1="680" y1="200" x2="680" y2="390"/>
</g>
<g fill="none" stroke="#1f2a3a" stroke-width="8">
  <circle cx="110" cy="400" r="48"/><circle cx="250" cy="400" r="48"/>
  <path d="M110 400 L160 330 L230 330 L250 400 M160 330 L190 400 L110 400 M230 330 L220 305 L250 305"/>
  <circle cx="380" cy="400" r="48"/><circle cx="520" cy="400" r="48"/>
  <path d="M380 400 L430 330 L500 330 L520 400 M430 330 L460 400 L380 400 M500 330 L490 305 L520 305"/>
  <circle cx="620" cy="400" r="48"/><circle cx="760" cy="400" r="48"/>
  <path d="M620 400 L670 330 L740 330 L760 400 M670 330 L700 400 L620 400 M740 330 L730 305 L760 305"/>
</g>
<g fill="#e94b3c"><rect x="150" y="318" width="30" height="10"/><rect x="420" y="318" width="30" height="10"/>
<rect x="660" y="318" width="30" height="10"/></g>
<circle cx="680" cy="40" r="45" fill="#ffd54a"/>
</svg>'''


# ---------------------------------------------------------------- nội dung đề
def q(n, answer, content=None, options=None, explanation=None):
    d = {'number': n, 'answer': answer}
    if content:
        d['content'] = content
    if options:
        d['options'] = options
    if explanation:
        d['explanation'] = explanation
    return d


def letters(stmts):
    return ' '.join(f'({chr(65 + i)}) {s}' for i, s in enumerate(stmts))


def build():
    os.makedirs(OUT, exist_ok=True)
    tmp = tempfile.mkdtemp()
    groups = []

    # ----- Part 1: mô tả tranh (options không in, chỉ đọc trong audio)
    p1 = [
        (1, SVG_DESK, 'B', [
            'A woman is typing on a keyboard.',
            'A laptop has been left open on a desk.',
            'Some chairs are stacked in a corner.',
            'A plant is being watered.',
        ], 'Tranh chỉ có đồ vật: laptop mở trên bàn → (B). Không có người nên loại (A), (D).'),
        (2, SVG_BIKES, 'A', [
            'Some bicycles are parked along a fence.',
            'A man is repairing a tire.',
            'Cars are stopped at a traffic light.',
            'A fence is being painted.',
        ], 'Ba chiếc xe đạp dựng dọc hàng rào → (A). "is being painted" cần có người đang sơn.'),
    ]
    for n, svg, ans, stmts, exp in p1:
        lines = [('N', f'Number {n}. Look at the picture marked number {n} in your test book.')]
        lines += [('N', f'({chr(65 + i)}) {s}') for i, s in enumerate(stmts)]
        groups.append({
            'part': 1,
            'image': make_image(svg, f'p1_q{n}', tmp),
            'audio': make_audio(lines, f'p1_q{n}', tmp),
            'transcript': letters(stmts),
            'questions': [q(n, ans, explanation=exp)],
        })

    # ----- Part 2: hỏi - đáp (3 lựa chọn, không in)
    p2 = [
        (7, 'Where is the quarterly report?', ["It's on your desk.", 'Every three months.',
         'Yes, I reported it.'], 'A', 'Hỏi "Where" → trả lời vị trí (A). (B) bẫy từ "quarterly".'),
        (8, 'When does the training session start?', ['In the main conference room.',
         'At nine thirty tomorrow.', 'Mr. Lee is training.'], 'B', 'Hỏi "When" → thời gian (B).'),
        (9, 'Would you like me to order lunch for the meeting?', ['That would be great, thanks.',
         'The meeting room is booked.', 'I had a sandwich.'], 'A', 'Lời đề nghị → nhận lời (A).'),
    ]
    for n, ques, resp, ans, exp in p2:
        lines = [('N', f'Number {n}.'), ('M', ques)]
        lines += [('W', f'({chr(65 + i)}) {r}') for i, r in enumerate(resp)]
        groups.append({
            'part': 2,
            'audio': make_audio(lines, f'p2_q{n}', tmp),
            'transcript': f'M: {ques}\nW: {letters(resp)}',
            'questions': [q(n, ans, explanation=exp)],
        })

    # ----- Part 3: hội thoại
    convo = [
        ('W', 'Hi Tom, the printer on the third floor is out of toner again. Do we have any replacements?'),
        ('M', "I'm afraid we used the last cartridge yesterday. I'll place an order with our supplier this afternoon."),
        ('W', 'Thanks. In the meantime, can I use the printer in your department? I need to print handouts for a client meeting at two.'),
        ('M', 'Of course. Just send the file to the printer near the reception desk.'),
    ]
    groups.append({
        'part': 3,
        'audio': make_audio([('N', 'Questions 32 through 34 refer to the following conversation.')] + convo,
                            'p3_q32-34', tmp),
        'transcript': '\n'.join(f'{s}: {t}' for s, t in convo),
        'questions': [
            q(32, 'A', 'What problem does the woman mention?',
              ['A printer is out of toner.', 'A meeting was canceled.', 'A file is missing.',
               'A client is late.'], '"the printer ... is out of toner again".'),
            q(33, 'B', 'What will the man do this afternoon?',
              ['Repair a printer', 'Place an order', 'Meet a client', 'Print some handouts'],
              '"I\'ll place an order with our supplier this afternoon".'),
            q(34, 'C', 'Why does the woman need to print documents?',
              ['For a job interview', 'For a training session', 'For a client meeting',
               'For a sales report'], '"print handouts for a client meeting at two".'),
        ],
    })

    # ----- Part 4: bài nói
    talk = ('Attention, shoppers. Thank you for visiting Greenfield Market. Starting this Saturday, our store '
            'will open at seven a.m. instead of eight to better serve our early customers. Also, this weekend '
            'only, all fresh fruit is twenty percent off. Don\'t forget to sign up for our rewards card at the '
            'customer service desk to receive a free reusable shopping bag.')
    groups.append({
        'part': 4,
        'audio': make_audio([('N', 'Questions 71 through 73 refer to the following announcement.'), ('A', talk)],
                            'p4_q71-73', tmp),
        'transcript': talk,
        'questions': [
            q(71, 'D', 'Where is the announcement being made?',
              ['At an airport', 'At a bank', 'At a library', 'At a supermarket'],
              '"shoppers", "Greenfield Market", "fresh fruit" → siêu thị.'),
            q(72, 'A', 'What will change starting on Saturday?',
              ["The store's opening time", "The store's location", 'Payment methods', 'Parking rules'],
              '"will open at seven a.m. instead of eight".'),
            q(73, 'B', 'What can listeners receive at the customer service desk?',
              ['A discount coupon', 'A shopping bag', 'A store map', 'A refund'],
              '"sign up ... to receive a free reusable shopping bag".'),
        ],
    })

    # ----- Part 5: hoàn thành câu
    p5 = [
        q(101, 'B', 'Ms. Park was ------- promoted to regional manager after only two years with the company.',
          ['quick', 'quickly', 'quicker', 'quickness'], 'Bổ nghĩa cho động từ "promoted" → trạng từ "quickly".'),
        q(102, 'A', 'Please contact the front desk ------- you need additional towels.',
          ['if', 'so', 'but', 'or'], 'Câu điều kiện: liên hệ lễ tân NẾU cần thêm khăn → "if".'),
        q(103, 'A', "The board of directors will ------- the proposal at next week's meeting.",
          ['discuss', 'discussion', 'discussed', 'discussing'], 'Sau "will" là động từ nguyên mẫu → "discuss".'),
        q(104, 'C', 'Neither the manager ------- her assistant was available to answer the call.',
          ['or', 'and', 'nor', 'but'], 'Cấu trúc "neither ... nor".'),
    ]
    groups += [{'part': 5, 'questions': [x]} for x in p5]

    # ----- Part 6: hoàn thành đoạn văn
    groups.append({
        'part': 6,
        'passage': ('Dear valued clients,\n\nWe are pleased to announce that Brightline Consulting ---(131)--- '
                    'to a new office on March 1. Our new address is 250 Harbor Street, Suite 12. The new '
                    'location offers more meeting space and is ---(132)--- accessible by public transportation. '
                    '---(133)--- Please update your records ---(134)---.\n\nSincerely,\nBrightline Consulting'),
        'questions': [
            q(131, 'B', options=['moved', 'will be moving', 'has been moved', 'moving'],
              explanation='Thông báo trước ngày 1/3 → tương lai "will be moving".'),
            q(132, 'B', options=['easy', 'easily', 'easier', 'ease'],
              explanation='Bổ nghĩa cho tính từ "accessible" → trạng từ "easily".'),
            q(133, 'A', options=[
                'Our phone numbers and email addresses will remain the same.',
                'The building was constructed in 1985.',
                'Our staff enjoyed the holiday party.',
                'Parking fees have recently increased.'],
              explanation='Câu (A) liền mạch: đổi địa chỉ nhưng liên lạc giữ nguyên, rồi "update your records".'),
            q(134, 'B', options=['according', 'accordingly', 'accordance', 'accord'],
              explanation='Cuối câu cần trạng từ → "accordingly" (cho phù hợp).'),
        ],
    })

    # ----- Part 7: đọc hiểu (đoạn đơn + đoạn kép)
    groups.append({
        'part': 7,
        'passage': ('RIVERSIDE PUBLIC LIBRARY\nExtended Hours for Exam Season\n\nFrom May 1 to May 31, the '
                    'library will stay open until 10 p.m. on weekdays. Study rooms can be reserved up to three '
                    'days in advance at the information desk or on our website. Please note that food is not '
                    'allowed in study rooms; drinks must be in covered containers.'),
        'questions': [
            q(147, 'A', 'What is the purpose of the notice?',
              ['To announce longer opening hours', 'To introduce new staff', 'To advertise a book sale',
               'To explain a temporary closure'], '"Extended Hours ... stay open until 10 p.m.".'),
            q(148, 'C', 'What is indicated about the study rooms?',
              ['They are free only on weekends.', 'Food may be eaten in them.',
               'They can be reserved in advance.', 'They are closed in May.'],
              '"can be reserved up to three days in advance".'),
        ],
    })
    groups.append({
        'part': 7,
        'passage': ('E-MAIL 1\nFrom: Laura Chen <lchen@sunrisehotel.com>\nTo: David Kim <dkim@apexsoft.com>\n'
                    'Subject: Conference room booking\n\nDear Mr. Kim,\nThank you for choosing Sunrise Hotel for '
                    "your company's workshop on June 12. As requested, we have reserved the Ocean Room, which "
                    'seats 40 people. Lunch will be served at 12:30 p.m. Please confirm the final number of '
                    'participants by June 5.\n\nBest regards,\nLaura Chen, Events Coordinator\n\n'
                    '────────────\n\nE-MAIL 2\nFrom: David Kim\nTo: Laura Chen\nSubject: RE: Conference room '
                    'booking\n\nDear Ms. Chen,\nThank you for the confirmation. We now expect 45 participants, '
                    'so we will need a larger room. Also, could lunch be moved to 1:00 p.m.? Our morning session '
                    'will run longer than planned.\n\nRegards,\nDavid Kim'),
        'questions': [
            q(176, 'B', 'Who most likely is Ms. Chen?',
              ['A software developer', 'An events coordinator', 'A workshop speaker', 'A travel agent'],
              'Chữ ký: "Laura Chen, Events Coordinator".'),
            q(177, 'D', 'Why does Mr. Kim need a different room?',
              ['The Ocean Room is being renovated.', 'He wants a room with a view.',
               'The workshop date has changed.', 'More people will attend than the room holds.'],
              'Phòng Ocean chứa 40 người (e-mail 1) nhưng giờ có 45 người (e-mail 2) → kết hợp 2 đoạn.'),
            q(178, 'A', 'What does Mr. Kim ask Ms. Chen to do?',
              ['Change the lunch time', 'Cancel the reservation', 'Send an invoice',
               'Arrange transportation'], '"could lunch be moved to 1:00 p.m.?".'),
        ],
    })

    test = {
        'title': 'Sample Full Test 01 (đủ 7 Part)',
        'source': 'Bami TOEIC',
        'description': 'Đề mẫu tự soạn, 24 câu, đủ Part 1–7, có audio (giọng đọc máy) và ảnh. '
                       'Dùng để test chức năng, không phản ánh độ khó thật.',
        'groups': groups,
    }
    with open(os.path.join(OUT, 'test.json'), 'w', encoding='utf-8') as f:
        json.dump(test, f, ensure_ascii=False, indent=2)
    shutil.rmtree(tmp)
    n = sum(len(g['questions']) for g in groups)
    print(f'✅ {OUT}: {len(groups)} nhóm, {n} câu')


if __name__ == '__main__':
    build()
