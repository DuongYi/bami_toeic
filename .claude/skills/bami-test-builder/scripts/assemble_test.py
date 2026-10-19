#!/usr/bin/env python3
"""Ghép <dir>/meta.json + <dir>/parts/p1..p7.json → <dir>/test.json (bản cũ lưu thành test.json.bak).

  python3 assemble_test.py content/tests/bami_full_03
Sau khi ghép LUÔN chạy normalize_test.py (xáo đáp án) – test.json mới ghép chưa được cân bằng.
"""
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from _common import load, save, test_dir  # noqa: E402


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    d = test_dir(sys.argv[1])
    meta = load(d / 'meta.json')
    groups = []
    for part in range(1, 8):
        f = d / 'parts' / f'p{part}.json'
        if f.exists():
            chunk = load(f)
            if not isinstance(chunk, list):
                sys.exit(f'{f}: phải là mảng các nhóm')
            groups += chunk
    if not groups:
        sys.exit(f'Không có nhóm nào trong {d}/parts')
    keys = ('title', 'source', 'description', 'is_free', 'time_limit_minutes', 'score_table', 'collection')
    out = {k: v for k, v in meta.items() if k in keys}
    out['groups'] = groups
    if (d / 'test.json').exists():
        shutil.copy(d / 'test.json', d / 'test.json.bak')
    save(d / 'test.json', out)
    n = sum(len(g['questions']) for g in groups)
    print(f'✅ {d}/test.json: {len(groups)} nhóm · {n} câu. Tiếp: normalize_test.py {d}')


if __name__ == '__main__':
    main()
