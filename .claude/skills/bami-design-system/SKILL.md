---
name: bami-design-system
description: Design system của app Flutter Bami TOEIC (token màu/chữ/khoảng cách/bo góc/motion, AppTone, component dùng chung, dialog/snackbar/sheet). BẮT BUỘC đọc trước khi tạo hoặc sửa bất kỳ UI nào trong lib/ (page, widget, màn hình, layout, style, màu, padding, theme), khi review UI, hoặc khi thêm token/component mới vào lib/core/design_system/.
---

# Bami TOEIC Design System

Mọi UI dùng **một nguồn style duy nhất**: `lib/core/design_system/`. Không hard-code màu, cỡ chữ, khoảng cách, bo góc, kích thước, thời lượng animation, dialog hay snackbar.

```dart
import '../../../../core/design_system/design_system.dart'; // import duy nhất cho UI
```

Nền tảng: Material 3 (seed `#1E5EFF`), WCAG 2.2 AA, lưới 4/8, tiếng Việt (line-height ≥ 1.4).
Trang Gallery mọi component: route `/design-system` (chỉ bản debug), mở bằng icon 🎨 trên màn Đề thi.

## 1. Quy trình bắt buộc khi làm UI

1. Tìm trong **Component catalog** (mục 4) trước. Có sẵn thì dùng, KHÔNG tự viết lại.
2. Thiếu component thì dựng từ widget Material và **token**. Nếu dùng lại ≥ 2 nơi, thêm vào design system (mục 7).
3. Thiết kế đủ trạng thái: dữ liệu / loading / lỗi + Thử lại / rỗng (dùng `AsyncView`, `AppEmptyView`).
4. Chạy kiểm tra:
   ```bash
   flutter analyze
   flutter test test/design_system_lint_test.dart test/design_system_widget_test.dart
   ```
   `design_system_lint_test` **fail** khi có hard-code. Sửa theo message, không tắt test.

## 2. Token

### Màu: `context.colors` (ColorScheme M3) và `context.appColors`
| Mục đích | Dùng |
|---|---|
| Hành động chính, link, nhấn mạnh | `colors.primary` / `onPrimary` |
| Nền khối nổi bật nhẹ | `colors.primaryContainer` / `onPrimaryContainer` |
| Nền card | để `Card`/`AppCard` tự lo (`surfaceContainerLow`) |
| Chữ phụ, icon phụ | `colors.onSurfaceVariant` |
| Viền, divider | `colors.outlineVariant` (nhạt), `colors.outline` |
| Lỗi, phá huỷ | `colors.error`, `errorContainer` |
| Đúng / thành công | `appColors.success`, `successContainer` (hoặc `AppTone.success`) |
| Cảnh báo / trung bình | `appColors.warning`, `warningContainer` (hoặc `AppTone.warning`) |

- Luôn cặp **x / onX** và **xContainer / onXContainer**. Không đặt chữ `primary` lên nền `primaryContainer` khi chưa kiểm tra.
- `AppPalette` là primitive, **chỉ dùng bên trong design_system/**.
- Dark mode và high-contrast tự có (`AppTheme.dark/lightHighContrast/darkHighContrast`). Đừng tự kiểm tra `Brightness`.

### AppTone: sắc thái trạng thái
`AppTone.success | warning | danger | info | neutral`. Mỗi tone có `icon` và `colorsOf(context)` trả về `ToneColors(main, onMain, container, onContainer)`.
- `AppTone.fromRatio(r)`: ≥ 0.7 success, ≥ 0.5 warning, còn lại danger. Đây là **ngưỡng chuẩn toàn app** cho tỉ lệ đúng.
- Map nghiệp vụ: đáp án đúng = success, chọn sai = danger, bỏ trống = neutral, từ mới = info, từ cần ôn = warning; flashcard Quên/Khó/Nhớ/Dễ = danger/warning/success/info.
- **Không truyền đạt ý nghĩa chỉ bằng màu**: luôn kèm icon (`tone.icon`) hoặc chữ.

### Chữ: `context.textStyles`
| Vai trò | Style |
|---|---|
| Số liệu lớn (điểm) | `displaySmall` |
| Từ vựng trên flashcard, điểm phụ | `headlineSmall` |
| Tiêu đề sheet/dialog | `titleLarge` |
| Tiêu đề section, tiêu đề item | `titleMedium` (đã w600) |
| Nội dung đọc (passage, câu hỏi) | `bodyLarge` |
| Văn bản thường | `bodyMedium` (mặc định của `Text`) |
| Chú thích, mô tả phụ | `bodySmall` |
| Nhãn nút / chip | `labelLarge` / `labelMedium` / `labelSmall` |

Được `copyWith(color:, fontWeight:, fontStyle:)`. **Cấm `fontSize`**. Không tự set `height`.

### Khoảng cách, bo góc, kích thước, motion
| Token | Giá trị | Dùng cho |
|---|---|---|
| `AppSpacing.s2…s48` | 2,4,8,12,16,24,32,48 | padding / spacing của Wrap, Row… |
| `AppSpacing.screen` | 16 | lề ngang màn hình |
| `AppInsets.screen` / `.screenH` / `.card` / `.cardLarge` / `.listBottomForFab` | | EdgeInsets dựng sẵn |
| `Gaps.v4…v48`, `Gaps.h4…h24` | | khoảng trống trong Column / Row |
| `AppRadius.xs…xl` + `brXs…brXl` | 4,8,12,16,28 | bo góc (`brMd` cho ô/option, `brLg` card, `brXl` dialog) |
| `AppSizes.touchTarget` | 48 | vùng chạm tối thiểu |
| `AppSizes.buttonLarge` | 52 | chiều cao CTA |
| `AppSizes.iconSm/Md/Lg/Xl/Hero` | 18/24/32/56/64 | icon |
| `AppSizes.formMaxWidth` | 400 | form trên màn rộng |
| `AppMotion.short/medium/long` | 150/250/450ms | animation, luôn bọc `AppMotion.of(context, d)` để tôn trọng Reduce Motion |
| `AppMotion.standard/emphasized` | | curve |

Cần giá trị chưa có thì **thêm token**, không viết số trực tiếp.

## 3. Định dạng & chữ (tiếng Việt)

- Ngày giờ / phần trăm / đồng hồ: `Fmt.date`, `Fmt.dateTime`, `Fmt.clock`, `Fmt.percent` (`lib/helper/format.dart`).
- Thuật ngữ nút thống nhất: **Lưu, Huỷ, Xoá, Thử lại, Đóng, Tiếp tục, Nộp bài, Làm tiếp, Thoát, Ở lại**.
- Thông báo lỗi = `AppException.from(e).message`, không hiện exception thô.
- Câu ngắn, nói việc cần làm. Trạng thái rỗng phải nói lý do + bước tiếp theo.

## 4. Component catalog

| Component | Khi nào dùng |
|---|---|
| `AppPrimaryButton(label, onPressed, icon?, loading?, expand=true)` | CTA chính, **tối đa 1/màn**, đặt cố định ở đáy (`SafeArea` + `AppInsets.screen`) nếu là hành động kết thúc màn |
| `FilledButton.tonal` / `OutlinedButton` / `TextButton` | hành động phụ (đã có theme, không tự style) |
| `AppInlineSpinner()` | spinner nhỏ trong nút / AppBar |
| `AppCard(child, padding?, onTap?, tone?)` | khối nội dung; `tone: AppTone.info` cho thẻ nổi bật |
| `SectionHeader(title, subtitle?, trailing?)` | tiêu đề nhóm (đã gắn semantics heading) |
| `StatusBadge(label, tone, icon?)` | nhãn trạng thái nhỏ |
| `ToneIcon(tone, semanticLabel)` | icon đúng/sai/cảnh báo có nhãn đọc |
| `AppProgressBar(value, tone?)` | thanh tiến độ (tự tone theo `fromRatio`) |
| `LabeledProgress(label, value, trailing)` | dòng "nhãn … 12/20" + thanh |
| `StatTile(value, label, highlight?)` | ô số liệu trong `Row` (tự `Expanded`) |
| `NumberCell(number, tone?/filled?/current?, onTap, semanticLabel)` | ô số câu (bảng chọn câu, bảng đáp án) |
| `AsyncView(value, data, onRetry)` | render `AsyncValue` (loading / lỗi + Thử lại / data) |
| `AppLoadingView` / `AppErrorView` / `AppEmptyView(icon, message, action?)` | trạng thái màn hình |
| `ScrollableFill(child)` | bọc Empty/Error trong `RefreshIndicator` để vẫn kéo-làm-mới |
| `showAppConfirmDialog(context, title, message?, confirmLabel, cancelLabel, destructive)` → `Future<bool>` | mọi xác nhận; `destructive: true` cho xoá/thoát mất dữ liệu |
| `showAppSnackBar(context, msg, tone?, actionLabel?, onAction?)` | thông báo ngắn, "Thử lại", "Hoàn tác" |
| `showAppSnackBarOn(messenger, …)` | khi widget có thể bị gỡ sau `await` (vd. Dismissible) |
| `showAppBottomSheet(context, builder)` | form/tác vụ phụ (drag handle, safe area, tránh bàn phím) |

Component nghiệp vụ (nằm trong module, đã dùng token): `AnswerOption`, `QuestionGroupView`, `AudioBar` (`module/test/presentation/widgets/`).

## 5. Mẫu màn hình chuẩn

```dart
class XxxPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(xxxProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tiêu đề')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(xxxProvider.future),
        child: AsyncView(
          value: data,
          onRetry: () => ref.invalidate(xxxProvider),
          data: (items) => items.isEmpty
              ? const ScrollableFill(
                  child: AppEmptyView(icon: Icons.inbox_outlined, message: 'Chưa có … Bấm + để thêm.'),
                )
              : ListView(
                  padding: AppInsets.screen,
                  children: [
                    const SectionHeader(title: 'Nhóm'),
                    AppCard(child: Text('…', style: context.textStyles.bodyLarge)),
                    Gaps.v16,
                  ],
                ),
        ),
      ),
    );
  }
}
```

Xoá có xác nhận + báo lỗi:
```dart
if (await showAppConfirmDialog(context, title: 'Xoá mục này?', confirmLabel: 'Xoá', destructive: true)) {
  try { await ref.read(xxxProvider.notifier).delete(id); }
  catch (e) { if (context.mounted) showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger); }
}
```

## 6. Accessibility (bắt buộc)

- Vùng chạm ≥ 48dp (theme đã đặt cho nút; widget tự chế dùng `AppSizes.touchTarget`).
- `IconButton` luôn có `tooltip`. Widget tương tác tự chế bọc `Semantics(button:, selected:, label:)`.
- Tiêu đề nhóm dùng `SectionHeader` (heading). Ảnh có `Semantics(image: true, label:)`.
- Thao tác vuốt (Dismissible) phải có cách thay thế: `onLongPress` + `customSemanticsActions`.
- Không chặn cỡ chữ hệ thống; layout phải chịu được text scale 200% (gallery test kiểm tra).
- Animation qua `AppMotion.of(context, …)`.

## 7. Thêm / sửa token hoặc component

1. Token: thêm vào `tokens/app_dimens.dart` (spacing/radius/sizes/motion) hoặc `tokens/app_colors.dart` (đủ 4 biến thể light/dark/lightHC/darkHC, tương phản ≥ 4.5:1; `test/design_system_widget_test.dart` sẽ kiểm tra).
2. Component: file mới trong `components/`, chỉ dùng token, có semantics. `export` trong `design_system.dart`.
3. Thêm mục vào `gallery/ds_gallery_page.dart`, cập nhật bảng ở mục 4 của file này.
4. Style mặc định cho widget Material thì sửa `theme/app_theme.dart`, không style lẻ ở từng màn.
5. Chạy `flutter analyze && flutter test`.

## 8. Ngoại lệ

Chỉ khi thật sự không có token phù hợp (vd. giá trị đến từ dữ liệu, không phải style): thêm `// ds-ignore: <lý do>` ở **cuối đúng dòng** đó. Không dùng để né quy tắc.

## 9. Checklist trước khi xong

- [ ] Chỉ import `design_system.dart`, không còn `Theme.of(context)` lặp lại (dùng `context.colors/textStyles/appColors`)
- [ ] Không số literal cho padding/gap/radius/size/duration; không `Colors.*` (trừ `transparent`); không `fontSize`
- [ ] Dialog/snackbar/sheet qua helper `showApp*`
- [ ] Đủ trạng thái loading/lỗi/rỗng; CTA chính ≤ 1 và ở vùng ngón cái
- [ ] Trạng thái có icon/chữ, không chỉ màu; IconButton có tooltip
- [ ] `flutter analyze` sạch, `flutter test` pass (gồm `design_system_lint_test`)
