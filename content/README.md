# Định dạng nội dung

## Đề thi: `content/tests/<tên-thư-mục>/test.json`

Đặt file audio/ảnh cùng thư mục với `test.json` và tham chiếu bằng tên file. Script sẽ upload lên Supabase Storage.

```jsonc
{
  "title": "ETS 2024 - Test 1",        // bắt buộc, duy nhất
  "source": "ETS 2024",
  "description": "…",
  "groups": [                           // theo đúng thứ tự trong đề
    // Part 1: 1 nhóm / câu, có ảnh + audio, options để trống
    { "part": 1, "audio": "q1.mp3", "image": "q1.jpg", "transcript": "(A) … (B) …",
      "questions": [{ "number": 1, "answer": "B", "explanation": "…" }] },

    // Part 2: 1 nhóm / câu, 3 lựa chọn A-C
    { "part": 2, "audio": "q7.mp3", "transcript": "…",
      "questions": [{ "number": 7, "answer": "C" }] },

    // Part 3/4: 1 nhóm = 1 đoạn hội thoại + 3 câu (ảnh biểu đồ tuỳ chọn)
    { "part": 3, "audio": "q32-34.mp3", "transcript": "M: … W: …",
      "questions": [
        { "number": 32, "content": "What are the speakers discussing?",
          "options": ["…", "…", "…", "…"], "answer": "A" }
      ] },

    // Part 5: 1 nhóm / câu
    // Part 6, 7: 1 nhóm = 1 đoạn văn ("passage") + các câu hỏi
    { "part": 7, "passage": "…", "image": "q176.png", "questions": [ … ] }
  ]
}
```

- `answer`: `A`–`D`. `number`: 1–200, không trùng.
- `audio` / `image` có thể là URL `https://…` thay vì file.
- Có 1 file audio dài cho cả phần Listening? Cắt theo từng nhóm (Audacity, hoặc `ffmpeg -ss 00:01:20 -to 00:01:52 -i full.mp3 -c copy q7.mp3`).

Import:

```bash
dart run tool/import_test.dart content/tests/ets2024_test1            # thêm mới
dart run tool/import_test.dart content/tests/ets2024_test1 --replace  # ghi đè
dart run tool/import_test.dart content/tests/ets2024_test1 --dry-run  # chỉ kiểm tra, không ghi
```

Mẹo: chụp/scan đề, nhờ AI chuyển sang đúng định dạng JSON ở trên rồi tự soát lại đáp án.

## Đề mẫu có sẵn

| Thư mục | Nội dung |
|---|---|
| `content/tests/sample_test` | Mini Test 01: 12 câu Part 5–7, không audio |
| `content/tests/sample_full_test` | Sample Full Test 01: 24 câu **đủ Part 1–7**, có audio (giọng đọc máy) và ảnh Part 1. Dựng lại bằng `python3 tool/build_sample_full_test.py` (macOS) |

## Từ vựng: CSV

Cột: `word,ipa,pos,meaning,example,example_meaning,topic` (xem `vocab_sample.csv`).

Import: Supabase Dashboard → Table Editor → bảng `vocab` → **Insert → Import data from CSV**.
Hoặc từ file JSON (mảng `{word, ipa, pos, meaning, example, example_meaning, topic}`), upsert theo (word, topic):
`dart run tool/import_vocab.dart <file.json> [--dry-run]`.
Hoặc thêm từng từ ngay trong app (nút +).

## Chuyển sách PDF scan (ETS 2026) thành đề

Nguồn: `content/LISTENING/` (PDF + `Audio/E26-Tnn-*.mp3`) và `content/READING/` — đều bị `.gitignore`.
Công cụ (macOS, không cần cài thêm): `tool/pdf_tool.swift` (PDFKit + Vision OCR) và `tool/ets/`.

```bash
# 1. OCR có toạ độ (một lần, ~20 phút)
W=content/raw/ets2026
OCR_TSV=1 swift tool/pdf_tool.swift ocr "content/LISTENING/LISTENING ETS 2026.pdf" 1 140 > $W/lc.tsv
OCR_TSV=1 OCR_DPI=300 swift tool/pdf_tool.swift ocr "content/READING/READING ETS 2026.pdf" 1 300 > $W/rc300.tsv && touch $W/rc300.done
OCR_TSV=1 OCR_LANGS=en-US,ko-KR swift tool/pdf_tool.swift ocr "content/LISTENING/TRANSCRIPT.pdf" 5 296 > $W/tr.tsv
# 2. Đáp án → $W/keys.json (tool/ets/extract_keys.py, soát tay ô thiếu)
# 3. Dựng đề → content/tests/ets2026_testNN/ (ảnh Part 1, biểu đồ, ảnh đoạn văn Part 7, audio AAC 48 kbps)
python3 tool/ets/build_ets.py 1-10
python3 tool/ets/audit.py 1-10          # soát lỗi OCR còn sót
#    Đầu vào thêm (nếu có): $W/explanations/testNN_{lc,rc56,rc7}.json (giải thích, kiểm bằng check_explanations.py),
#    $W/transcripts/testNN.json (transcript Part 3/4 sạch, kiểm bằng check_transcripts_p34.py).
#    Thẻ dạng câu (tags) tự gắn bởi tool/ets/tagging.py.
# 4. Sửa tay câu OCR hỏng: $W/overrides.json {"test": {"câu": {"content", "options"}}} rồi chạy lại bước 3
# 5. Đẩy lên Supabase (hỏi email/mật khẩu 1 lần)
bash tool/ets/import_all.sh
# 6. Sửa nội dung sau khi đã import (giữ id, không mất lịch sử làm bài): chữ, giải thích, thẻ dạng câu, ảnh
dart run tool/sync_text.dart content/tests/ets2026_test* --images
# 7. Từ vựng: $W/vocab/testNN.json → gộp, bỏ trùng → import
python3 tool/ets/merge_vocab.py && dart run tool/import_vocab.dart $W/vocab/ets2026_all.json
```
