# Quy cách đề ETS (rút ra từ 10 đề ETS 2026 trong `content/tests/ets2026_test*`)

## Định dạng `test.json`

```jsonc
{
  "title": "Bami Full Test 03",          // duy nhất trong DB
  "source": "Bami TOEIC",                // nhãn nguồn hiện trong app
  "description": "…",                    // 1 câu, tiếng Việt
  "groups": [ /* theo đúng thứ tự đề, số câu tăng dần */ ]
}
```

Nhóm (`group`): `part`, `questions`, và tuỳ Part: `audio`, `image`, `transcript`, `passage`.
Câu (`question`): `number`, `answer` (`A`–`D`), `explanation` (tiếng Việt), `tags`, và tuỳ Part: `content`, `options`.
`audio` / `image` là tên file nằm cùng thư mục `test.json` (hoặc URL). Tuỳ chọn: `"fixed_order": true` ở câu có
phương án phải giữ thứ tự (giờ, ngày, số tăng dần) – `normalize_test.py` sẽ không xáo câu đó.

## Từng Part

| Part | Câu | Nhóm | Trường của nhóm | Trường của câu |
|---|---|---|---|---|
| 1 Mô tả tranh | 1–6 | 6 × 1 câu | `audio`, `image`, `transcript` | `answer`, `explanation`, `tags:["photo"]` – **không** `content`/`options` |
| 2 Hỏi – đáp | 7–31 | 25 × 1 câu | `audio`, `transcript` | như Part 1, **3 phương án A–C** |
| 3 Hội thoại | 32–70 | 13 × 3 câu | `audio`, `transcript`, `image` (chỉ nhóm có biểu đồ) | `content`, `options`(4) |
| 4 Bài nói | 71–100 | 10 × 3 câu | như Part 3 | `content`, `options`(4) |
| 5 Điền câu | 101–130 | 30 × 1 câu | – | `content` (có `-------`), `options`(4) |
| 6 Điền đoạn | 131–146 | 4 × 4 câu | `passage` (chỗ trống `---(131)---`) | `options`(4) – **không** `content` |
| 7 Đọc hiểu | 147–200 | 15 nhóm | `passage`, `image` (tuỳ chọn) | `content`, `options`(4) |

Tỉ lệ đáp án trong 10 đề thật: A 24% · B 27% · C 26% · D 24% (Part 2: A 28% · B 37% · C 35%). Không có quy luật vị trí.

### Part 1 – Photographs
- `transcript` đúng 4 dòng: `(A) …\n(B) …\n(C) …\n(D) …`. App chỉ hiện nút A–D; câu nằm trong audio.
- Câu mô tả ngắn (6–12 từ), thì hiện tại tiếp diễn chủ động (`A woman is …ing`), bị động hiện tại hoàn thành
  (`Some chairs have been stacked`), bị động tiếp diễn (`… is being repaired` – chỉ đúng khi có người đang làm).
- 4 câu cùng chủ đề tranh; distractor: sai hành động, sai vật, đúng vật sai trạng thái, `is being` khi không có người.
- Ảnh có người (4/6) và ảnh cảnh vật (2/6), độ khó tăng dần câu 1 → 6.

### Part 2 – Question–Response
- `transcript`: dòng 1 là câu hỏi/câu nói, sau đó `(A)`, `(B)`, `(C)`.
- Phân bố câu mở đầu (25 câu): Wh- ~11 (How, When, Why, Where, Who, What, Which), Yes/No & phủ định ~5,
  tag question ~2, lựa chọn `A or B` ~2, đề nghị/yêu cầu (`Would you…`, `Let's…`, `Can you…`) ~3, câu trần thuật ~2.
- Đáp án đúng thường **gián tiếp** (`I'll check with Ms. Lee.`, `It's been postponed.`); distractor: lặp từ / từ gần
  âm với câu hỏi, trả lời Yes/No cho câu Wh-, sai thì / sai người.

### Part 3 – Conversations (32–70)
- 13 đoạn; 2 đoạn có **3 người** (`M1:`, `M2:`, `W:` hoặc `W1:`, `W2:`, `M:`); còn lại `M:` / `W:` xen kẽ, 6–10 lượt.
- 3 nhóm cuối (62–64, 65–67, 68–70) có **biểu đồ** (`image`: lịch, bảng giá, sơ đồ, danh sách) và đúng 1 câu
  `Look at the graphic. …` mỗi nhóm.
- ~2 câu hàm ý: `What does the woman mean when she says, "…"?` / `Why does the man say, "…"?`
- Câu hỏi 1 thường là ý chính / người nói / địa điểm, câu 2 chi tiết / vấn đề, câu 3 hành động tiếp theo / đề nghị.
- Phương án là cụm danh từ hoặc câu ngắn, **paraphrase** lời thoại (không lặp nguyên văn).

### Part 4 – Talks (71–100)
- 10 bài: tin nhắn thoại, thông báo, quảng cáo, tin tức, giới thiệu diễn giả, hướng dẫn tham quan, họp nội bộ.
  1 người nói, `transcript` là đoạn văn liền (không nhãn người nói).
- Nhóm 95–97 và 98–100 có biểu đồ + 1 câu `Look at the graphic.` mỗi nhóm. ~3 câu hàm ý / đề.

### Part 5 – Incomplete Sentences
- 1 câu, 1 chỗ trống `-------` (7 dấu gạch). 30 câu ≈ từ loại 8–10, từ vựng 8–10, giới từ/liên từ 4–5,
  thì/dạng động từ 3–4, đại từ 2–3.
- 4 phương án cùng dạng (cùng gốc từ cho câu từ loại; cùng từ loại cho câu từ vựng).

### Part 6 – Text Completion
- 4 đoạn (email, thông báo, quảng cáo, bài báo ngắn), mỗi đoạn 4 chỗ trống `---(131)---` … `---(134)---` trong `passage`.
- Mỗi đoạn **đúng 1 câu chèn câu** (phương án là 4 câu hoàn chỉnh), 3 câu còn lại: từ loại / từ vựng / thì / liên từ
  phải đọc ngữ cảnh mới chọn được (vd. thì tương lai vì email nói về sự kiện sắp tới).

### Part 7 – Reading Comprehension (147–200)
- 15 nhóm: **10 đoạn đơn** (147–175, kích thước 2/2/2/2/3/3/3/4/4/4 câu, thứ tự có thể xen kẽ),
  **2 đoạn kép** (176–180, 181–185), **3 đoạn ba** (186–190, 191–195, 196–200).
- Có ít nhất: 1 chuỗi tin nhắn (2 câu) + 1 cuộc chat nhiều người (4 câu), mỗi cái có 1 câu
  `At 10:15 A.M., what does Ms. X most likely mean when she writes, "…"?`
- 2 câu chèn câu: `In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? "…"`,
  `options` = `["[1]", "[2]", "[3]", "[4]"]`, passage chứa `[1]` … `[4]`.
- ~2 câu `NOT` (`What is NOT mentioned…`), ~4 câu từ đồng nghĩa (`The word "…" in paragraph 2, line 3, is closest in meaning to`).
- Đoạn kép / ba: mỗi nhóm 1–2 câu phải **kết hợp thông tin 2 văn bản** (tag `multi-passage`).
- Nhiều văn bản trong 1 `passage`: phân tách bằng tiêu đề loại văn bản, vd. `E-mail`, `Invoice`, `Web page` trên dòng riêng.

## Tags (dùng đúng các khoá này – `tool/ets/tagging.py`)

`photo` · `wh-question` · `yes-no` · `tag-question` · `choice` · `request` · `statement` · `main-idea` ·
`speaker-identity` · `detail` · `next-action` · `request-suggestion` · `implied-meaning` · `graphic` · `inference` ·
`vocab-in-context` · `sentence-insertion` · `multi-passage` · `word-form` · `verb-form` · `pronoun` ·
`preposition-conjunction` · `vocabulary`

## Ảnh

- Part 1 cần ảnh thật khớp **đúng 1** câu mô tả. Thứ tự ưu tiên: ảnh người dùng cung cấp → ảnh stock giấy phép mở
  (Unsplash / Pexels, ghi nguồn vào `description`) → ảnh minh hoạ SVG đơn giản chuyển PNG bằng
  `qlmanage -t -s 1200 -o <dir> file.svg` (chỉ là tạm thời – báo người dùng).
- Biểu đồ Part 3/4/7 (lịch, bảng giá, sơ đồ tầng): vẽ SVG rõ chữ → PNG như trên. Nội dung biểu đồ phải cần thiết để trả lời câu `Look at the graphic`.
- Ảnh ≤ 1200 px cạnh dài, `.png` / `.jpg`.
