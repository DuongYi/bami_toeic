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
```

Mẹo: chụp/scan đề, nhờ AI chuyển sang đúng định dạng JSON ở trên rồi tự soát lại đáp án.

## Từ vựng: CSV

Cột: `word,ipa,pos,meaning,example,example_meaning,topic` (xem `vocab_sample.csv`).

Import: Supabase Dashboard → Table Editor → bảng `vocab` → **Insert → Import data from CSV**.
Hoặc thêm từng từ ngay trong app (nút +).
