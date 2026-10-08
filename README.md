# Bami TOEIC

App Flutter ôn luyện TOEIC cá nhân. Backend là Supabase (gói Free): Postgres + Storage + Auth.

## Tính năng

- **Đề thi**: làm theo Part hoặc full test. Chế độ *Luyện tập* (hiện đáp án và giải thích ngay) hoặc *Thi thử* (tính giờ, chấm khi nộp). Có audio (tua, đổi tốc độ), ảnh phóng to, transcript.
- **Kết quả**: số câu đúng, điểm quy đổi ước tính (khi làm đủ 100 câu L/R), thống kê theo Part, xem lại từng câu.
- **Từ vựng**: danh sách theo chủ đề, tìm kiếm, thêm/sửa/xoá. Flashcard lặp lại ngắt quãng (SM-2): Quên / Khó / Nhớ / Dễ.
- **Tiến độ**: lịch sử làm bài, tỉ lệ đúng theo Part, Part yếu nhất.

## Cài đặt (khoảng 15 phút, làm một lần)

### 1. Tạo Supabase project
1. Đăng ký tại https://supabase.com → **New project** (chọn region Singapore cho gần VN).
2. **SQL Editor → New query** → dán toàn bộ `supabase/schema.sql` → **Run**.
3. **Authentication → Users → Add user → Create new user**: nhập email và mật khẩu, tick *Auto Confirm User*.
4. **Authentication → Sign In / Providers**: tắt **Allow new users to sign up**. Chỉ bạn đăng nhập được.
5. **Project Settings → API Keys**: copy *Project URL* và *Publishable key*.

### 2. Cấu hình app
```bash
cp env.example.json env.json   # điền URL + publishable key vào env.json
flutter pub get
flutter run --dart-define-from-file=env.json
```
Android Studio: *Run → Edit Configurations → Additional run args*: `--dart-define-from-file=env.json`.

### 3. Nạp dữ liệu
```bash
dart run tool/import_test.dart content/tests/sample_test   # đề mẫu
```
Từ vựng mẫu: import `content/vocab_sample.csv` vào bảng `vocab` (xem `content/README.md`).

### 4. Cài lên điện thoại
- Android: `flutter build apk --release --dart-define-from-file=env.json`, rồi copy file `build/app/outputs/flutter-apk/app-release.apk` sang máy và cài.
- iPhone: cắm cáp, `flutter run --release --dart-define-from-file=env.json`. Với Apple ID miễn phí, app hết hạn sau 7 ngày, chạy lại lệnh này để gia hạn.

## Cấu trúc

```
supabase/schema.sql          Bảng, RLS, storage bucket
tool/import_test.dart        Script import đề (JSON + media → Supabase)
content/                     Dữ liệu đề / từ vựng + hướng dẫn định dạng
lib/
  config/                    env, theme
  core/                      Supabase client, widget dùng chung
  helper/                    quy đổi điểm, thuật toán SRS
  routes/app_router.dart     go_router + chặn khi chưa đăng nhập
  module/
    auth/                    đăng nhập
    test/                    danh sách đề, làm bài, kết quả
    vocab/                   từ vựng, flashcard
    history/                 tiến độ
```

## Lưu ý gói Free
- Project bị **tạm dừng nếu 7 ngày không có request**. Dữ liệu vẫn còn, vào dashboard bấm *Restore*.
- Giới hạn: 500 MB database, 1 GB storage. Một đề full khoảng 30–50 MB audio, nên lưu được khoảng 20 đề. Muốn nhiều hơn thì nén audio xuống mono 64 kbps (`ffmpeg -i in.mp3 -ac 1 -b:a 64k out.mp3`), đề khi đó chỉ còn khoảng 15 MB.

## Lộ trình

- [x] **Giai đoạn 1 – Nền tảng**: schema, đăng nhập, điều hướng
- [x] **Giai đoạn 2 – Làm đề**: luyện tập / thi thử, audio, chấm điểm, xem lại
- [x] **Giai đoạn 3 – Từ vựng**: CRUD, flashcard SRS
- [x] **Giai đoạn 4 – Tiến độ**: lịch sử, thống kê theo Part
- [ ] **Giai đoạn 5 – Nạp nội dung thật**: chuyển đề bạn có sang JSON, cắt audio, import
- [ ] **Giai đoạn 6 – Nâng cấp**:
  - Đọc phát âm từ vựng (`flutter_tts`), thêm từ trực tiếp từ câu hỏi đang làm
  - Sổ câu sai: luyện lại các câu từng làm sai
  - Lưu bài đang làm dở (thoát app không mất bài)
  - Cache offline (tải trước đề và audio)
  - Nhắc ôn từ vựng hằng ngày (local notification)
