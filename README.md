# Bami TOEIC

App Flutter ôn luyện TOEIC cá nhân. Backend là Supabase (gói Free): Postgres + Storage + Auth, gọi qua REST bằng Dio.

**Stack:** Riverpod 3 (codegen `@riverpod`) · Dio + Retrofit · Freezed + json_serializable · go_router · flutter_secure_storage · just_audio

## Tính năng

- **Đề thi**: làm theo Part hoặc full test. Chế độ *Luyện tập* (hiện đáp án và giải thích ngay) hoặc *Thi thử* (tính giờ, chấm khi nộp). Có audio (tua, đổi tốc độ), ảnh phóng to, transcript.
- **Kết quả**: số câu đúng, điểm quy đổi ước tính (khi làm đủ 100 câu L/R), thống kê theo Part, xem lại từng câu.
- **Từ vựng**: danh sách theo chủ đề, tìm kiếm, thêm/sửa/xoá. Flashcard lặp lại ngắt quãng (SM-2): Quên / Khó / Nhớ / Dễ.
- **Bài làm dở**: tự lưu trên máy (mỗi 10 giây, khi chọn đáp án, khi thoát/đưa app xuống nền). Mở lại đề → *Tiếp tục* hoặc *Làm lại từ đầu*. Đánh dấu câu (cờ) để xem lại trước khi nộp.
- **Sổ câu sai**: câu sai/bỏ trống ở lần làm gần nhất, gom theo Part và dạng câu; luyện lại, làm đúng thì câu tự ra khỏi sổ.
- **Tiến độ**: lịch sử làm bài, tỉ lệ đúng theo Part, Part yếu nhất, dạng câu yếu nhất (từ loại, suy luận, đọc biểu đồ…).
- **Thi thử như thật**: phần nghe phát liền mạch Part 1–4 (không tua), tự chuyển câu theo audio; phiếu tô đáp án kiểu OMR trong bảng chọn câu.
- **Tra từ trong đề**: bôi đen từ trong câu hỏi/đoạn văn/transcript → *Tra từ* (tìm cả dạng biến đổi) hoặc thêm vào sổ từ.
- **Luyện nghe**: chép chính tả từng đoạn Part 1–4, chấm theo từ, xem transcript để nói theo.
- **Mục tiêu & chuỗi ngày học**: điểm mục tiêu, ngày thi, chỉ tiêu mỗi ngày, nhắc học bằng thông báo; điểm dự đoán từ full test hoặc tỉ lệ đúng.
- **Offline**: tải đề (nội dung + audio + ảnh) về máy ở trang chi tiết đề.
- **Media riêng tư**: bucket `media` không public, app dùng URL ký tạm (12 giờ).
- **Theo từng tài khoản, đồng bộ nhiều máy**: lượt làm bài, lịch ôn SRS, bài làm dở, chuỗi ngày học, mục tiêu đều lưu theo user (RLS). Ghi vào máy trước, có mạng thì đồng bộ. Từ vựng: bộ chung (ETS) + từ riêng của mỗi người; đề và media chỉ admin (`app_admins`) được sửa.
- **Bảng quy đổi điểm theo đề**: cột `tests.score_table` (để trống thì dùng công thức ước tính).

## Cài đặt (khoảng 15 phút, làm một lần)

### 1. Tạo Supabase project
1. Đăng ký tại https://supabase.com → **New project** (chọn region Singapore cho gần VN).
2. **SQL Editor → New query** → dán toàn bộ `supabase/schema.sql` → **Run**.
   Project tạo trước 10/2026: chạy thêm `supabase/migrations/002_learning_features.sql` (thẻ dạng câu, sổ câu sai, bucket riêng tư) `003_score_table.sql` và `004_per_user_sync.sql` (dữ liệu học theo user, đồng bộ nhiều máy, quyền admin).
3. **Authentication → Users → Add user → Create new user**: nhập email và mật khẩu, tick *Auto Confirm User*.
4. **Authentication → Sign In / Providers**: tắt **Allow new users to sign up**. Chỉ bạn đăng nhập được.
5. **Project Settings → API Keys**: copy *Project URL* và *Publishable key*.

### 2. Cấu hình app
```bash
cp env.example.json env.json   # điền URL + publishable key vào env.json
flutter pub get
dart run build_runner build      # sinh *.g.dart / *.freezed.dart
flutter run --dart-define-from-file=env.json
```
Android Studio: *Run → Edit Configurations → Additional run args*: `--dart-define-from-file=env.json`.

### 3. Nạp dữ liệu
```bash
dart run tool/import_test.dart content/tests/sample_test   # đề mẫu
```
Từ vựng mẫu: import `content/vocab_sample.csv` vào bảng `vocab` (xem `content/README.md`).
Bộ từ vựng ETS 2026: `python3 tool/ets/merge_vocab.py && dart run tool/import_vocab.dart content/raw/ets2026/vocab/ets2026_all.json`.

### 4. Cài lên điện thoại
- Android: `flutter build apk --release --dart-define-from-file=env.json`, rồi copy file `build/app/outputs/flutter-apk/app-release.apk` sang máy và cài.
- iPhone: cắm cáp, `flutter run --release --dart-define-from-file=env.json`. Với Apple ID miễn phí, app hết hạn sau 7 ngày, chạy lại lệnh này để gia hạn.

## Kiến trúc

```
lib/
  config/                       env (dart-define), theme
  core/
    network/
      dio_client.dart           dioProvider: baseUrl, apikey, interceptors
      auth_interceptor.dart     gắn Bearer token, tự refresh (QueuedInterceptor) khi sắp hết hạn / 401
      error_interceptor.dart    DioException → AppException
      app_exception.dart        lỗi chuẩn hoá: Network / Unauthorized / NotFound / Server / Unknown
      postgrest.dart            hằng số header PostgREST, helper Pg.eq()
    storage/token_storage.dart  lưu session trong Keychain/Keystore
    widgets/                    AsyncView, EmptyView
  helper/                       quy đổi điểm, thuật toán SRS (SM-2)
  routes/app_router.dart        routerProvider: go_router + redirect theo AuthController
  module/<feature>/
    data/
      models/                   DTO freezed (fromJson) + input (toJson)
      <feature>_api.dart        Retrofit: khai báo endpoint /rest/v1, /auth/v1
      <feature>_repository.dart query PostgREST, logic dữ liệu; provider của Api & Repository
    presentation/
      controllers/              @riverpod provider / Notifier (state + hành động)
      pages/, widgets/          UI, chỉ watch controller
```

**Luồng dữ liệu:** `Page → Controller (Riverpod) → Repository → Api (Retrofit) → Dio (+interceptors) → Supabase`.

- **Auth:** `AuthController` (keepAlive) là nguồn duy nhất về trạng thái đăng nhập. Router lắng nghe để chuyển Splash → Login → App. Khi refresh token hết hạn, interceptor gọi `onSessionExpired()` và app tự quay về màn Login.
- **Làm bài:** `TestTaking` controller giữ đáp án, đồng hồ, chế độ, nộp bài. Các widget con dùng `select` để mỗi giây chỉ có đồng hồ rebuild.
- **Từ vựng:** `VocabList` (CRUD), `VocabFilter` (chủ đề/từ khoá), `vocabOverview` (số liệu dẫn xuất), `FlashcardSession` (phiên ôn SRS).
- Sửa model/API/controller xong thì chạy `dart run build_runner watch -d` trong lúc dev.

## Design system

`lib/core/design_system/` chứa token (màu M3 + success/warning, `AppTone`, spacing, radius, sizes, motion), theme light/dark/high-contrast và component dùng chung. UI chỉ import `design_system.dart`. Quy tắc chi tiết cho người và agent: `.claude/skills/bami-design-system/SKILL.md`. Xem trực quan mọi component ở route `/design-system` (bản debug, icon 🎨 trên màn Đề thi).

## Test

```bash
flutter test   # SRS, điểm, JSON, AuthInterceptor, lint design system, tương phản WCAG, gallery
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
