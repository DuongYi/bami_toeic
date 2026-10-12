---
name: bami-test-builder
description: Tạo đề TOEIC mới (full 200 câu, mini 25 câu, quick 15 câu, luyện từng Part) cho app Bami TOEIC theo chuẩn đề ETS thật – soạn nội dung, cân bằng đáp án, tạo audio, kiểm tra và import lên Supabase. BẮT BUỘC dùng khi người dùng muốn tạo / sinh / viết đề thi, mini test, đề luyện Part, sửa đề tự tạo bị lộ đáp án, hoặc kiểm tra một test.json trong content/tests/.
---

# Bami Test Builder

Sinh đề TOEIC **giống đề ETS thật** ở định dạng `content/tests/<id>/test.json` rồi import bằng `tool/import_test.dart`.
Đề mẫu chuẩn để đối chiếu: `content/tests/ets2026_test01..10/test.json` (OCR từ sách ETS 2026, đã soát).

Đọc thêm khi cần:
- `references/ets-spec.md` – quy cách từng Part (BẮT BUỘC đọc trước khi soạn).
- `references/blueprints.md` – cấu trúc full / mini25 / quick15 / part-practice, đánh số câu.
- `references/writing-guide.md` – cách viết câu hỏi, distractor, transcript, giải thích; độ khó theo band điểm.

## Lỗi đã từng gặp (đề tự tạo trước đây) – không được lặp lại

| Lỗi | Hậu quả | Quy tắc |
|---|---|---|
| Part 1/2 điền `content` + `options` bằng câu trong audio | App in sẵn các câu lên màn hình → thi như đọc, lộ đáp án | Part 1/2 **không có** `content`, `options`; câu chỉ nằm trong `transcript` (hiện khi xem lại) |
| Đáp án đúng gần như luôn là (A) | Chọn bừa A cũng được 90% | Soạn xong **luôn chạy** `normalize_test.py` để xáo phương án, sau đó mới tạo audio |
| Part 6 có `content` kiểu "Choose the best preposition…" | Lộ dạng câu hỏi | Part 6 không có `content`; chỗ trống đánh dấu `---(131)---` trong `passage` |
| Viết đề trong file Dart khổng lồ (`tool/data_part*.dart`) | Lỗi cú pháp làm hỏng `flutter analyze` / `build_runner` | Soạn thẳng JSON theo từng Part trong `content/tests/<id>/parts/` |
| "Extreme" = từ chuyên ngành hiếm, đảo ngữ văn chương | Không giống đề thật | Độ khó đến từ paraphrase, bẫy, suy luận – xem `writing-guide.md` |

## Quy trình

Đặt `S=.claude/skills/bami-test-builder/scripts`, `D=content/tests/<id>` (id: `snake_case`, vd. `bami_full_03`, `mini_test06`, `quick15_test06`).

1. **Chốt yêu cầu**: loại đề (blueprint), band điểm mục tiêu, số đề, chủ đề cần tránh trùng với đề đã có (`ls content/tests`).
2. **Tạo khung**: `python3 $S/new_test.py $D --blueprint full|mini25|quick15|part:5 --title "…"`
   → `$D/meta.json` + `$D/parts/pN.json` có sẵn số câu, số nhóm đúng blueprint (giá trị `TODO`).
3. **Soạn từng Part** (mỗi lần 1 file `parts/pN.json`, đề full nên làm lần lượt P1 → P7 để không tràn ngữ cảnh):
   theo `ets-spec.md` + `writing-guide.md`. Viết đáp án đúng ở bất kỳ vị trí nào – bước 5 sẽ xáo.
   Trong `explanation` chỉ gọi phương án bằng dạng `(A)`…`(D)` để script đổi chữ cái đúng khi xáo.
4. **Ghép**: `python3 $S/assemble_test.py $D` → `$D/test.json`.
5. **Chuẩn hoá + cân bằng đáp án**: `python3 $S/normalize_test.py $D --seed <số>`
   (xáo phương án về bảng đáp án cân bằng, sửa `(X)` trong giải thích, sắp lại câu (A)–(D) trong transcript Part 1/2,
   gỡ `content`/`options` Part 1/2 và `content` Part 6 nếu lỡ có). Chạy lại an toàn; `--dry-run` để xem trước.
6. **Kiểm tra**: `python3 $S/validate_test.py $D --blueprint <bp>` → sửa đến khi **0 lỗi**; cảnh báo phải đọc và giải thích được.
7. **Media**:
   - Audio Part 1–4: `python3 $S/build_audio.py $D` (giọng macOS `say` Mỹ/Anh/Úc, đọc lời dẫn + câu hỏi như đề thật, AAC 48 kbps).
     Phải chạy **sau** bước 5 (thứ tự (A)–(D) đọc trong audio Part 1/2 phụ thuộc kết quả xáo).
   - Ảnh Part 1 / biểu đồ Part 3, 4, 7: xem mục "Ảnh" trong `ets-spec.md`. Hỏi người dùng nguồn ảnh nếu chưa có.
   - Chạy lại `validate_test.py $D --media` để chắc file đã đủ.
8. **Import**: `dart run tool/import_test.dart $D --dry-run`, rồi bảo người dùng chạy
   `! dart run tool/import_test.dart $D` (cần đăng nhập admin; thêm `--replace` để ghi đè đề cùng tên – mất lịch sử làm bài của đề đó).
9. **Xác nhận trên DB** (Supabase MCP `execute_sql`): đủ số câu, Part 1/2 `options = '[]'` và `content is null`,
   phân bố đáp án theo Part. Báo lại người dùng: số câu, phân bố đáp án, cảnh báo còn lại, việc họ cần làm.

## Sửa nội dung sau khi đã ghép

- Đề có `parts/`: sửa `parts/pN.json` → `assemble_test.py` → `normalize_test.py --seed <cùng seed>` → `validate_test.py` → `build_audio.py`.
  Không sửa tay `test.json` của đề có `parts/` (lần ghép sau sẽ ghi đè).
- Đề không có `parts/` (đề cũ): sửa thẳng `test.json`, rồi chạy lại normalize → validate → build_audio.
- `build_audio.py` chỉ tạo lại file có kịch bản đổi; đổi `--gap` / `--rate` thì thêm `--force`.

## Sửa đề đã import bị lộ đáp án

1. Sửa `test.json` gốc: `normalize_test.py` → `validate_test.py` → `build_audio.py` (audio Part 1/2 đổi thứ tự).
2. Import lại với `--replace` (đề tự tạo thường chưa có lịch sử làm bài đáng giữ – vẫn hỏi người dùng trước).

## Ranh giới

- Không sao chép nguyên văn câu hỏi ETS có bản quyền vào đề mới; chỉ học cấu trúc, dạng câu, văn phong.
- Không tự import / ghi đè dữ liệu Supabase khi người dùng chưa đồng ý.
- Không sửa `tool/import_test.dart` hay schema chỉ để đề "lọt" – sửa đề cho đúng chuẩn.
