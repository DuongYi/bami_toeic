# Hướng dẫn viết câu hỏi

## Văn phong ETS

- Bối cảnh công sở & đời sống thường ngày: văn phòng, nhân sự, tài chính cơ bản, mua sắm, du lịch, nhà hàng,
  sản xuất, bất động sản, sự kiện, chăm sóc khách hàng, giao thông. **Không** y khoa, pháp lý, kỹ thuật sâu.
- Tên người đa quốc tịch (Ms. Tanaka, Mr. Okafor, Priya Shah), công ty / địa điểm hư cấu, số điện thoại `555-01xx`,
  website `www.<tên>.com`. Không dùng thương hiệu thật, người thật.
- Ngữ pháp trong sáng, câu vừa phải. Không đảo ngữ văn chương, không thành ngữ hiếm, không tiếng lóng.
- Mỗi câu có **đúng 1** đáp án bảo vệ được bằng bằng chứng trong đề; distractor sai rõ ràng khi đọc kỹ.

## Distractor theo Part

| Part | Kiểu distractor nên dùng |
|---|---|
| 1 | Đúng vật sai hành động; `is being` khi không ai làm; vật có trong tranh nhưng sai vị trí / trạng thái |
| 2 | Lặp từ hoặc từ gần âm (`copy` / `coffee`); trả lời Yes/No cho câu Wh-; đúng chủ đề sai thông tin (hỏi When đáp nơi chốn) |
| 3, 4 | Từ được nhắc trong audio nhưng không trả lời câu hỏi; chi tiết của người nói khác; suy diễn quá mức |
| 5 | Cùng gốc khác từ loại; từ đồng nghĩa gần nhưng sai collocation; thì sai mốc thời gian |
| 6 | Câu chèn: câu đúng chủ đề nhưng sai mạch (đại từ / từ nối không khớp câu trước sau) |
| 7 | Thông tin có trong bài nhưng thuộc người / thời điểm khác; khái quát quá mức; trái với bài |

Tránh lỗi lộ đáp án: đáp án đúng **không** được luôn dài nhất / chi tiết nhất; không chứa nguyên văn cụm từ
trong bài trong khi distractor thì không; 4 phương án cùng độ dài và cấu trúc ngữ pháp.

## Transcript & audio

- Part 1: chỉ 4 dòng `(A)`–`(D)`. Part 2: câu hỏi + `(A)`–`(C)`.
- Part 3: mỗi lượt 1 dòng `M: …` / `W: …` (3 người: `M1:`, `M2:`, `W:`). Câu hỏi 1–3 phải trả lời được theo thứ tự
  thông tin xuất hiện trong hội thoại.
- Part 4: 1 đoạn văn liền 90–140 từ, mở đầu nêu loại bài (`Good morning, everyone…`, `You've reached…`).
- Câu hàm ý: câu trích trong `content` phải xuất hiện **nguyên văn** trong transcript.
- `build_audio.py` đọc lời dẫn (`Number 7.`, `Questions 32 through 34 refer to the following conversation.`),
  đọc câu hỏi Part 3/4 sau hội thoại, chèn khoảng lặng trả lời – không cần ghi lời dẫn vào transcript.

## Giải thích (`explanation`, tiếng Việt)

Mẫu: dạng câu / căn cứ → bằng chứng trích tiếng Anh trong ngoặc đơn → đáp án `(X)` → vì sao 1–2 distractor sai.

> Hỏi 'Where' (ở đâu) → trả lời địa điểm 'At the Riverview Hotel' (B). (A) nói về kỳ nghỉ, (C) là tủ đồ — không hợp nghĩa.

- Gọi phương án **chỉ** bằng `(A)`–`(D)` (để `normalize_test.py` đổi đúng khi xáo). Không viết "đáp án A", "câu B".
- Part 5/6 nêu quy tắc ngữ pháp / nghĩa từ. Part 7 trích câu trong bài và nói nằm ở đoạn nào.

## Độ khó theo band

| Band mục tiêu | Part 2–4 | Part 5–6 | Part 7 |
|---|---|---|---|
| 450–600 | Câu hỏi trực tiếp, đáp án gần nguyên văn | Từ loại, giới từ cơ bản | Câu hỏi chi tiết, bài ngắn |
| 650–800 (chuẩn ETS) | ~1/3 đáp án gián tiếp; hàm ý 2–3 câu | Trộn đều; từ vựng tầm B2 | Suy luận, NOT, chèn câu, kết hợp đoạn |
| 850–990 (khó) | Đa số đáp án gián tiếp; distractor dùng từ nghe được | Từ vựng cận nghĩa, collocation, liên từ tinh tế | Paraphrase xa, suy luận 2 bước, chi tiết nằm ở văn bản thứ 3 |

Khó **không** có nghĩa là từ hiếm hay chủ đề chuyên ngành: giữ từ vựng TOEIC, tăng độ xa của paraphrase,
độ tinh của bẫy và số bước suy luận.
