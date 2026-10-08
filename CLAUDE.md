# Bami TOEIC – hướng dẫn cho agent

App Flutter ôn luyện TOEIC cá nhân, backend Supabase (REST qua Dio). Trả lời người dùng bằng tiếng Việt.

## Quy tắc bắt buộc

- **UI**: trước khi tạo/sửa bất kỳ màn hình, widget, style nào → dùng skill `bami-design-system`
  (`.claude/skills/bami-design-system/SKILL.md`). Chỉ import `lib/core/design_system/design_system.dart`;
  không hard-code màu/chữ/khoảng cách/bo góc/kích thước/animation/dialog/snackbar.
  `test/design_system_lint_test.dart` sẽ fail nếu vi phạm.
- **State**: Riverpod 3 codegen (`@riverpod`). Controller nằm ở `module/<feature>/presentation/controllers/`.
  State tạm thời của UI (TextEditingController, tab đang chọn) để trong widget.
- **Network**: Retrofit API (`data/<feature>_api.dart`) → Repository (`data/<feature>_repository.dart`)
  → Controller. Không gọi Dio trực tiếp từ UI/controller. Lỗi hiển thị bằng `AppException.from(e).message`.
- **Model**: freezed + json_serializable (snake_case tự động qua `build.yaml`). Body gửi lên dùng class
  `@JsonSerializable(createFactory: false)`. DateTime gửi lên phải `.toUtc()`.
- Sửa model/API/provider xong: `dart run build_runner build`. Không sửa tay `*.g.dart`, `*.freezed.dart`.

## Lệnh

```bash
dart run build_runner build                  # sinh code
flutter analyze                              # phải sạch
flutter test                                 # gồm lint design system + contrast + gallery
flutter run --dart-define-from-file=env.json
```

## Cấu trúc

```
lib/core/design_system/   tokens/, theme/, components/, gallery/ (route /design-system, debug)
lib/core/network/         dio_client, auth_interceptor, error_interceptor, app_exception
lib/helper/               score, srs, format (Fmt.*)
lib/module/<feature>/     data/{models, *_api, *_repository} + presentation/{controllers, pages, widgets}
supabase/schema.sql       schema + RLS + storage
tool/import_test.dart     import đề từ content/
```
