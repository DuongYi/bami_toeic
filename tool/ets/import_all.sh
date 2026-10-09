#!/bin/bash
# Đẩy cả bộ ETS 2026 (đã dựng bằng tool/ets/build_ets.py) lên Supabase.
#   bash tool/ets/import_all.sh          # import đề chưa có
#   bash tool/ets/import_all.sh --replace  # ghi đè đề đã có
set -e
cd "$(dirname "$0")/../.."
read -p "Email: " TOEIC_EMAIL
read -s -p "Mật khẩu: " TOEIC_PASSWORD; echo
export TOEIC_EMAIL TOEIC_PASSWORD
for dir in content/tests/ets2026_test*/; do
  echo "=== $(basename "$dir") ==="
  dart run tool/import_test.dart "$dir" "$@" || echo "⚠️  Lỗi ở $dir (chạy lại với --replace nếu đề đã tồn tại)"
done
