"""Phần dùng chung cho các script của skill bami-test-builder (Python 3.9+, chỉ thư viện chuẩn)."""
import json
import re
from pathlib import Path

LETTERS = 'ABCD'

TAGS = {
    'photo', 'wh-question', 'yes-no', 'tag-question', 'choice', 'request', 'statement', 'main-idea',
    'speaker-identity', 'detail', 'next-action', 'request-suggestion', 'implied-meaning', 'graphic', 'inference',
    'vocab-in-context', 'sentence-insertion', 'multi-passage', 'word-form', 'verb-form', 'pronoun',
    'preposition-conjunction', 'vocabulary',
}

# Câu đánh dấu (A) trong transcript Part 1/2: "(A) …" ở đầu dòng hoặc liền trên 1 dòng.
OPTION_MARK = re.compile(r'\(([A-D])\)\s*')
# Chữ cái phương án trong giải thích: (A) … (D)
LETTER_REF = re.compile(r'\(([A-D])\)')
# Nhãn người nói Part 3: M:, W:, M1:, W2:
SPEAKER = re.compile(r'^\s*([MW]\d?)\s*:\s*(.*)$')


def _range(a, b, size=1):
    return [list(range(n, min(n + size, b + 1))) for n in range(a, b + 1, size)]


def _p7_singles(start, sizes):
    out, n = [], start
    for s in sizes:
        out.append(list(range(n, n + s)))
        n += s
    return out


def blueprint_groups(name):
    """Danh sách (part, [số câu], {cờ}) theo thứ tự đề."""
    g = []

    def add(part, groups, graphic=()):
        for nums in groups:
            g.append((part, nums, {'graphic': nums[0] in graphic}))

    if name == 'full':
        add(1, _range(1, 6))
        add(2, _range(7, 31))
        add(3, _range(32, 70, 3), graphic=(62, 65, 68))
        add(4, _range(71, 100, 3), graphic=(95, 98))
        add(5, _range(101, 130))
        add(6, _range(131, 146, 4))
        add(7, _p7_singles(147, [2, 2, 2, 2, 3, 3, 3, 4, 4, 4]) + _range(176, 200, 5))
    elif name == 'mini25':
        add(1, _range(1, 2))
        add(2, _range(7, 9))
        add(3, [[32, 33, 34]])
        add(4, [[71, 72, 73]])
        add(5, _range(101, 105))
        add(6, [[131, 132, 133, 134]])
        add(7, [[147, 148], [149, 150, 151]])
    elif name == 'quick15':
        add(5, _range(101, 108))
        add(6, [[131, 132, 133, 134]])
        add(7, [[147, 148, 149]])
    elif name == 'listening50':
        add(1, _range(1, 3))
        add(2, _range(7, 17))
        add(3, _range(32, 49, 3), graphic=(47,))
        add(4, _range(71, 88, 3), graphic=(86,))
    elif name.startswith('part:'):
        part = int(name.split(':')[1])
        g = [x for x in blueprint_groups('full') if x[0] == part]
    else:
        raise SystemExit(f'Blueprint không hợp lệ: {name} (full | mini25 | quick15 | listening50 | part:N)')
    return g


def letters_for(part, q):
    n = len(q.get('options') or []) or (3 if part == 2 else 4)
    return LETTERS[:n]


def load(path):
    return json.loads(Path(path).read_text(encoding='utf-8'))


def save(path, data):
    Path(path).write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def test_dir(arg):
    p = Path(arg)
    if p.name == 'test.json':
        p = p.parent
    return p


def questions(data):
    for g in data['groups']:
        for q in g['questions']:
            yield g, q


def split_listening_transcript(text):
    """Tách transcript Part 1/2 → (câu hỏi hoặc '', {chữ: câu}). Chấp nhận (A) … trên 1 dòng hoặc nhiều dòng."""
    text = (text or '').strip()
    parts = OPTION_MARK.split(text)
    # Part 1/2 trong đề ETS không có nhãn người nói: bỏ "W: " đầu câu hỏi và "M:" thừa trước (A).
    head = re.sub(r'(^|\n)\s*[MW]\d?:\s*', r'\1', parts[0]).strip()
    opts = {}
    for i in range(1, len(parts) - 1, 2):
        opts[parts[i]] = re.sub(r'\s*\n?\s*[MW]\d?:\s*$', '', parts[i + 1]).strip()
    return head, opts


def join_listening_transcript(head, opts):
    lines = [head] if head else []
    lines += [f'({k}) {opts[k]}' for k in sorted(opts)]
    return '\n'.join(lines)
