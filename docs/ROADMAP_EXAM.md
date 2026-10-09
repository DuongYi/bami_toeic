# Kế hoạch phát triển module Làm đề (Examination)

> Cập nhật: 08/10/2026 · Module: `lib/module/test/` · Backend: Supabase (`supabase/schema.sql`)
>
> Quy ước khi triển khai: Riverpod codegen + Retrofit/Dio + freezed (xem `CLAUDE.md`); mọi UI theo skill
> `bami-design-system`; mỗi hạng mục xong phải `flutter analyze` sạch, `flutter test` pass và cập nhật golden
> (`flutter test --update-goldens test/goldens`).

---

## 0. Hiện trạng (đã có)

| Phần | Trạng thái |
|---|---|
| Danh sách đề (dashboard), chi tiết đề, chọn chế độ Luyện tập / Thi thử, chọn Part | ✅ |
| Làm bài theo nhóm câu, audio từng nhóm (tua, tốc độ), ảnh, passage, bảng số câu | ✅ |
| Luyện tập: hiện đáp án + giải thích ngay; Thi thử: đếm ngược, tự nộp khi hết giờ | ✅ |
| Nộp bài, chấm L/R, lưu `attempts` + `attempt_answers` | ✅ |
| Kết quả: % đúng, theo Part, điểm quy đổi ước tính, xem lại từng câu | ✅ |
| Tiến độ: lịch sử, độ chính xác theo Part (`part_stats`) | ✅ |
| Script import đề `tool/import_test.dart` (JSON + media → Supabase) | ✅ |

---

## 1. Lộ trình

| # | Hạng mục | Giá trị | Độ lớn | Ưu tiên |
|---|---|---|---|---|
| E1 | Lưu & tiếp tục bài làm dở ✅ | Không mất bài khi thoát/tắt app | M | **P0** |
| E2 | Audio Listening liên tục kiểu thi thật ✅ | Thi thử sát thật | L | **P0** |
| E3 | Sổ câu sai ✅ | Ôn tập hiệu quả nhất | M | **P1** |
| E4 | Đánh dấu câu (flag) ✅ | Xem lại trước khi nộp | S | P1 |
| E5 | Phiếu trả lời kiểu OMR ✅ | Tô nhanh như đề giấy | S | P2 |
| E6 | Bảng quy đổi điểm theo từng đề ✅ (hạ tầng; sách ETS 2026 không in bảng) | Điểm chính xác hơn | S | P2 |
| E7 | Gắn thẻ dạng câu hỏi + thống kê ✅ | Biết yếu ngữ pháp/dạng nào | M | P2 |

Thứ tự đề xuất: **E1 → E2 → E4 → E3 → E5 → E6 → E7** (E4 làm cùng lúc với E1 vì chung state).

---

## E1. Lưu & tiếp tục bài làm dở (P0)

**Mục tiêu**: thoát màn làm bài, tắt app, hết pin… vẫn tiếp tục đúng câu, đúng đáp án, đúng thời gian còn lại.

**Thiết kế**
- Lưu cục bộ (offline-safe), không cần mạng: thêm `shared_preferences`.
- `InProgressStore` (`lib/module/test/data/in_progress_store.dart`): key `in_progress/<testId>` → JSON
  `{mode, parts, startedAt, clockSeconds, index, answers{questionId: letter}, revealed[], flagged[]}`.
- `TestTaking` controller:
  - `build()`: nếu có bản lưu khớp `mode` + `parts` → khôi phục; ngược lại tạo mới.
  - Tự lưu (debounce 1s) mỗi khi chọn đáp án / đổi câu, và mỗi 10s cho đồng hồ.
  - Xoá bản lưu khi nộp thành công hoặc người dùng chọn "Làm lại từ đầu".
- Thi thử: thời gian **tiếp tục trừ** khi app ở nền? → Không (giống pause). Ghi rõ trong UI.

**UI**
- Màn chi tiết đề: nếu có bài dở → `AppBanner` (info) "Bạn đang làm dở 35/100 câu · còn 42:10" + nút
  **Tiếp tục** (CTA) và **Làm lại từ đầu** (TextButton, xác nhận destructive).
- Màn chủ: nhãn `StatusBadge` "Đang làm dở" trên thẻ đề.
- Dialog thoát đổi nội dung: "Bài làm sẽ được lưu, bạn có thể tiếp tục sau." (bỏ cảnh báo mất dữ liệu).

**Kiểm thử**
- Unit: serialize/deserialize snapshot; khôi phục đúng state; xoá sau khi nộp.
- Widget/golden: banner "Tiếp tục" trên màn chi tiết.

**Hoàn thành khi**: thoát giữa chừng → mở lại → tiếp tục đúng câu, đúng đáp án, đúng đồng hồ.

---

## E2. Audio Listening liên tục kiểu thi thật (P0)

**Mục tiêu**: Thi thử Listening dùng **một file audio chạy liên tục**, không tua/nghe lại, câu tự chuyển theo
audio; Luyện tập vẫn nghe lại từng đoạn.

**Database** (migration `supabase/migrations/002_listening_audio.sql`)
```sql
alter table public.tests add column if not exists listening_audio_url text;
alter table public.question_groups
  add column if not exists audio_start_ms int,
  add column if not exists audio_end_ms   int;
```

**Import** (`tool/import_test.dart` + `content/README.md`)
- `test.json` thêm `"listeningAudio": "listening_full.mp3"`; mỗi nhóm Part 1–4 thêm
  `"audioStart": "00:01:20"`, `"audioEnd": "00:01:52"` (thay cho `audio` riêng – vẫn hỗ trợ cả hai).
- Tool phụ `tool/audio_marks.md`: hướng dẫn lấy mốc thời gian bằng Audacity (Label Track → Export Labels)
  và script chuyển file labels → JSON.

**App**
- Luyện tập: `AudioBar` dùng `ClippingAudioSource(start, end)` của just_audio trên file liên tục.
- Thi thử (có Part 1–4): `ExamListeningController`
  - Một `AudioPlayer` cho cả phần Listening, tự phát khi bắt đầu, **ẩn thanh tua và tốc độ**.
  - Lắng nghe `positionStream` → tự `setIndex` sang nhóm có `audio_start_ms ≤ position`.
  - Người dùng vẫn được xem/đổi đáp án các câu đã qua (như thi thật trên giấy).
  - Hết audio → tự chuyển sang Part 5 và đồng hồ Reading 75 phút bắt đầu.
- Đồng hồ thi thử: tách **Listening (theo audio)** và **Reading (75 phút / 100 câu, chia tỉ lệ)**.

**Kiểm thử**: unit cho hàm map `position → groupIndex`; fake player trong test controller.

**Hoàn thành khi**: thi thử full test chạy audio liên tục 45 phút, câu tự chuyển, không tua được.

---

## E3. Sổ câu sai (P1)

**Mục tiêu**: tự gom các câu đã làm sai (lần gần nhất) để luyện lại tới khi đúng.

**Database** (migration `003_mistakes.sql`)
```sql
-- Lần trả lời gần nhất của mỗi câu (theo user, nhờ RLS + security_invoker)
create or replace view public.latest_answers with (security_invoker = true) as
select distinct on (aa.question_id)
       aa.question_id, aa.chosen, aa.is_correct, a.finished_at, q.part, q.test_id
from public.attempt_answers aa
join public.attempts a  on a.id = aa.attempt_id
join public.questions q on q.id = aa.question_id
order by aa.question_id, a.finished_at desc;
```
Câu "sai" = `is_correct = false` ở lần gần nhất → làm đúng lần sau tự ra khỏi sổ.

**App**
- `MistakeRepository` + `mistakesProvider` (nhóm theo Part, đếm số câu).
- Màn **Sổ câu sai** (vào từ tab Tiến độ và lối tắt ở màn chủ): danh sách theo Part, CTA "Luyện lại N câu".
- Luyện lại = phiên Luyện tập đặc biệt chỉ gồm các nhóm chứa câu sai; nộp như attempt bình thường
  (`mode = 'practice'`, thêm cột `source text default 'test'` = `'mistakes'` để lọc khỏi thống kê đề).

**Hoàn thành khi**: làm sai câu 101 → xuất hiện trong sổ → luyện lại đúng → biến mất.

---

## E4. Đánh dấu câu (P1)

- `TakingState.flagged: Set<String>`; nút cờ (IconButton có tooltip "Đánh dấu") cạnh số câu.
- Bảng số câu (`NumberCell`) thêm trạng thái `flagged` (icon cờ góc + `AppTone.warning`) → cập nhật design system
  + gallery + skill.
- Dialog nộp bài: "Còn 3 câu đánh dấu, 5 câu bỏ trống" + nút "Xem câu đánh dấu".
- Lưu cùng snapshot E1.

---

## E5. Phiếu trả lời kiểu OMR (P2)

- Nút "Phiếu trả lời" trên AppBar → bottom sheet toàn màn hình: mỗi dòng `101 (A)(B)(C)(D)`, chạm để tô.
- Component mới `AnswerBubbleRow` trong design system (vùng chạm ≥ 48dp, semantics "Câu 101, đáp án B, đã chọn").
- Đồng bộ 2 chiều với state làm bài; chạm số câu → nhảy tới câu đó.

---

## E6. Bảng quy đổi điểm theo từng đề (P2)

- `alter table public.tests add column if not exists score_table jsonb;`
  dạng `{"listening": [5,5,5,10,…(101 phần tử)], "reading": [...]}`.
- `ToeicScore.listening(correct, table?)`: có bảng thì tra bảng, không có thì dùng công thức ước tính hiện tại.
- Import: `test.json` nhận `"scoreTable"`; màn kết quả bỏ chữ "ước tính" khi có bảng.

---

## E7. Gắn thẻ dạng câu hỏi + thống kê (P2)

- `alter table public.questions add column if not exists tags text[] not null default '{}';`
  Ví dụ thẻ: `tense`, `preposition`, `word-form`, `vocabulary`, `inference`, `detail`, `main-idea`.
- View `tag_stats` (giống `part_stats`, `unnest(q.tags)`).
- Import nhận `"tags": [...]` từng câu; có thể nhờ AI gắn thẻ hàng loạt rồi duyệt tay.
- Tab Tiến độ: section "Dạng câu yếu nhất" (top 3, `LabeledProgress`), chạm → luyện lại các câu cùng thẻ (dùng lại E3).

---

## 2. Việc song song: nạp đề thật

1. Chốt nguồn đề (PDF / ảnh / sách + mp3) và số lượng.
2. Viết công cụ chuyển hàng loạt sang `test.json` (OCR/AI → JSON → duyệt tay đáp án).
3. Chuẩn bị audio: file Listening liên tục + mốc thời gian (phục vụ E2); nén `ffmpeg -ac 1 -b:a 64k`.
4. Theo dõi dung lượng Supabase Free (1 GB storage, 500 MB DB).

---

## 3. Định nghĩa hoàn thành chung (mọi hạng mục)

- [ ] Migration SQL idempotent trong `supabase/migrations/`, đồng bộ vào `schema.sql`
- [ ] Model freezed + API retrofit + repository + controller `@riverpod`; `dart run build_runner build`
- [ ] UI chỉ dùng design system; component mới có trong gallery + skill
- [ ] Đủ trạng thái loading / lỗi / rỗng; accessibility (tooltip, semantics, vùng chạm)
- [ ] Unit test cho logic mới; golden cho màn mới/đổi; `flutter analyze` sạch; `flutter test` pass
- [ ] Cập nhật `README.md` / `content/README.md` nếu đổi định dạng dữ liệu
