#!/bin/sh
# Sao lưu phần làm tay của đề ETS (sửa OCR, giải thích, đáp án, từ vựng YBM) – content/raw/ bị .gitignore
# và chứa nội dung có bản quyền nên không đưa lên repo public. Bản nén ghi vào iCloud Drive (riêng tư, tự đồng bộ).
#
#   sh tool/backup_raw.sh            # → ~/Library/Mobile Documents/com~apple~CloudDocs/Bami TOEIC backup/raw-YYYYMMDD.zip
set -e
cd "$(dirname "$0")/../content/raw"
DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Bami TOEIC backup"
mkdir -p "$DEST"
OUT="$DEST/raw-$(date +%Y%m%d).zip"
rm -f "$OUT"
zip -qr "$OUT" ets2024/overrides ets2024/explanations ets2024/keys.json ets2024/keys_fix.json \
  ets2024/ybm_vocab.json ets2026/explanations ets2026/overrides.json ets2026/keys.json
echo "Đã sao lưu: $OUT ($(du -h "$OUT" | cut -f1))"
