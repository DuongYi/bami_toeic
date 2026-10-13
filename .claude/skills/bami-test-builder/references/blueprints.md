# Blueprint đề

Giữ **số câu theo đề thật** (Part 5 bắt đầu từ 101, Part 7 từ 147…) để người học nhận ra Part qua số câu,
kể cả khi đề ngắn (số câu nhảy cóc là bình thường). Thời gian thi: `time_limit_minutes` nếu có,
không thì app tính 120 phút × số câu / 200 (chọn bớt Part thì giảm theo tỉ lệ số câu).

| Blueprint | Câu | Cấu trúc (Part: số câu → số nhóm) | Thời gian app |
|---|---|---|---|
| `full` | 200 | P1 1–6 · P2 7–31 · P3 32–70 (13 nhóm, 3 cuối có biểu đồ, 2 nhóm 3 người) · P4 71–100 (10 nhóm, 2 cuối có biểu đồ) · P5 101–130 · P6 131–146 (4 đoạn) · P7 147–200 (10 đơn + 2 kép + 3 ba) | 120 phút |
| `mini25` | 25 | P1 1–2 · P2 7–9 · P3 32–34 (1 nhóm) · P4 71–73 (1 nhóm) · P5 101–105 · P6 131–134 (1 đoạn) · P7 147–148 + 149–151 (2 đoạn đơn) | 15 phút |
| `quick15` | 15 | P5 101–108 · P6 131–134 (1 đoạn) · P7 147–149 (1 đoạn đơn, 3 câu) | 15 phút (`time_limit_minutes: 15`, `new_test.py` tự đặt) |
| `listening50` | 50 | P1 1–3 · P2 7–17 · P3 32–49 (6 nhóm, nhóm cuối có biểu đồ) · P4 71–88 (6 nhóm, nhóm cuối có biểu đồ) | 30 phút |
| `reading7` | 22 | P7: 147–148 (chuỗi tin nhắn) · 149–151 (đoạn đơn) · 152–155 (chat nhiều người) · 156–158 (đoạn đơn có chèn câu [1]–[4]) · 176–180 (đoạn kép) · 186–190 (đoạn ba) | 13 phút |
| `listening234` | 42 | P2 7–21 · P3 32–46 (5 nhóm, nhóm 44–46 có biểu đồ) · P4 71–82 (4 nhóm, nhóm 80–82 có biểu đồ) | 25 phút |
| `part:N` | tuỳ | chỉ Part N, đánh số như đề thật, độ dài theo yêu cầu | theo số câu |

Ghi chú:
- Đề mini / quick nên trải đều dạng câu: P5 có từ loại + từ vựng + giới từ/liên từ; P7 có 1 câu suy luận.
- Đề theo bộ (vd. 5 mini test) phải khác chủ đề, khác tên người/công ty giữa các đề; dùng seed khác nhau ở `normalize_test.py`.
