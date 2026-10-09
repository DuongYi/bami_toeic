---
name: bami-design-system
description: "Design system của app Flutter Bami TOEIC (token màu/chữ/khoảng cách/bo góc/motion, AppTone, component dùng chung, dialog/snackbar/sheet, commercial components). BẮT BUỘC đọc trước khi tạo hoặc sửa bất kỳ UI nào trong lib/ (page, widget, màn hình, layout, style, màu, padding, theme), khi review UI, hoặc khi thêm token/component mới vào lib/core/design_system/."
---

# Bami TOEIC Design System

Mọi UI dùng **một nguồn style duy nhất**: `lib/core/design_system/`. Không hard-code màu, cỡ chữ, khoảng cách, bo góc, kích thước, thời lượng animation, dialog hay snackbar.

```dart
import '../../../../core/design_system/design_system.dart'; // import duy nhất cho UI
```

Nền tảng: Material 3 (seed `#1E5EFF`, `DynamicSchemeVariant.vibrant`: primary rực, container dịu), font **Be Vietnam Pro**, WCAG 2.2 AA, lưới 4/8, tiếng Việt (line-height ≥ 1.4).
Trang Gallery mọi component: route `/design-system` (chỉ bản debug), mở bằng icon 🎨 trên màn Đề thi.

## 1. Quy trình bắt buộc khi làm UI

1. Tìm trong **Component catalog** (mục 4) trước. Có sẵn thì dùng, KHÔNG tự viết lại.
2. Thiếu component thì dựng từ widget Material và **token**. Nếu dùng lại ≥ 2 nơi, thêm vào design system (mục 7).
3. Tuân thủ triệt để tiêu chuẩn chống AI-slop (`bami-ui-ux-pro`) và thương mại hoá (`bami-commercialization`).
4. Thiết kế đủ trạng thái: dữ liệu / loading / lỗi + Thử lại / rỗng (dùng `AsyncView`, `AppEmptyView`).
5. Chạy kiểm tra:
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
| Nền màn hình / khối nổi / viền mảnh | `context.surfaces.background` / `.raised` / `.hairline` (Card, ô nhập, sheet đã tự dùng) |
| Thẻ nổi bật (hero) | `AppHeroCard` (gradient `surfaces.hero`, chữ `surfaces.onHero`); không tự vẽ gradient |
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
| `AppSizes.iconXs/Sm/Md/Lg/Xl/Hero` | 12/18/24/32/56/64 | icon (Xs: icon phụ trong ô nhỏ) |
| `AppSizes.brandMark` | 88 | khối logo màn chào / đăng nhập |
| `AppSizes.badgeSm/Md/Lg` | 32/40/48 | IconBadge |
| `AppSizes.ringSm/Md/Lg` + `ringStrokeSm/Md/Lg` | 64/96/168 | ScoreRing |
| `AppSpacing.fabClearance` | 96 | khoảng trống cuối list có FAB |
| `AppMotion.short/medium/long` | 150/250/450ms | animation, luôn bọc `AppMotion.of(context, d)` để tôn trọng Reduce Motion |
| `AppMotion.standard/emphasized` | | curve |

Cần giá trị chưa có thì **thêm token**, không viết số trực tiếp.

## 3. Định dạng & chữ (tiếng Việt)

- Ngày giờ / phần trăm / đồng hồ: `Fmt.date`, `Fmt.dateTime`, `Fmt.clock`, `Fmt.percent` (`lib/helper/format.dart`).
- Thuật ngữ nút thống nhất: **Lưu, Huỷ, Xoá, Thử lại, Đóng, Tiếp tục, Nộp bài, Làm tiếp, Thoát, Ở lại**.
- Thông báo lỗi = `AppException.from(e).message`, không hiện exception thô.
- Câu ngắn, nói việc cần làm. Trạng thái rỗng phải nói lý do + bước tiếp theo.

## 4. Component catalog

### Nhóm thành phần chuẩn
| Component | Khi nào dùng |
|---|---|
| `AppPageHeader(title, overline?, trailing?)` | tiêu đề lớn cho **màn gốc của tab** (không dùng AppBar); màn con dùng AppBar |
| `AppBottomBar(child)` | thanh đáy cố định chứa CTA/điều hướng → `Scaffold.bottomNavigationBar` (tự co chiều cao) |
| `AppPrimaryButton(label, onPressed, icon?, loading?, expand=true)` | CTA chính, **tối đa 1/màn**, đặt trong `AppBottomBar` nếu là hành động kết thúc màn |
| `AppHeroCard(child)` | thông tin quan trọng nhất của màn (điểm, số từ cần ôn); **tối đa 1/màn**; chữ dùng `AppHeroCard.foreground(context)` |
| `ScoreRing(value, child, size?, strokeWidth?, tone?, color?, trackColor?)` | vòng tiến độ/điểm có nội dung ở giữa, có animation |
| `StatCard(icon, value, label, tone)` + `StatGrid(children)` | lưới 2 cột thẻ số liệu (thay hàng StatTile chật) |
| `ChoiceCard(title, subtitle?, icon?, selected, onTap, multiSelect?)` | lựa chọn có mô tả (chế độ làm bài, chọn Part); thay RadioListTile/CheckboxListTile |
| `IconBadge(icon, tone, size)` | icon trong ô màu; leading của item, card |
| `AppListGroup(children, dividerIndent?)` | nhóm ListTile trong 1 card, có divider mảnh (inset-grouped) |
| `FilledButton.tonal` / `OutlinedButton` / `TextButton` | hành động phụ (đã có theme, không tự style) |
| `AppInlineSpinner()` | spinner nhỏ trong nút / AppBar |
| `AppCard(child, padding?, onTap?, tone?)` | khối nội dung; `tone: AppTone.info` cho thẻ nổi bật |
| `AppBanner(message, tone, icon?)` | thông báo nằm trong nội dung: lỗi form (danger), cảnh báo, gợi ý (info); tự đọc bởi screen reader |
| `SectionHeader(title, subtitle?, trailing?)` | tiêu đề nhóm (đã gắn semantics heading) |
| `StatusBadge(label, tone, icon?)` | nhãn trạng thái nhỏ |
| `ToneIcon(tone, semanticLabel)` | icon đúng/sai/cảnh báo có nhãn đọc |
| `AppProgressBar(value, tone?)` | thanh tiến độ (tự tone theo `fromRatio`) |
| `LabeledProgress(label, value, trailing)` | dòng "nhãn … 12/20" + thanh |
| `StatTile(value, label, highlight?)` | ô số liệu trong `Row` (tự `Expanded`) |
| `NumberCell(number, tone?/filled?/current?/flagged?, onTap, semanticLabel)` | ô số câu (bảng chọn câu, bảng đáp án) |
| `AsyncView(value, data, onRetry)` | render `AsyncValue` (loading / lỗi + Thử lại / data) |
| `AppLoadingView` / `AppErrorView` / `AppEmptyView(icon, message, action?)` | trạng thái màn hình |
| `ScrollableFill(child)` | bọc Empty/Error trong `RefreshIndicator` để vẫn kéo-làm-mới |
| `showAppConfirmDialog(context, title, message?, confirmLabel, cancelLabel, destructive)` → `Future<bool>` | mọi xác nhận; `destructive: true` cho xoá/thoát mất dữ liệu |
| `showAppSnackBar(context, msg, tone?, actionLabel?, onAction?)` | thông báo ngắn, "Thử lại", "Hoàn tác" |
| `showAppSnackBarOn(messenger, …)` | khi widget có thể bị gỡ sau `await` (vd. Dismissible) |
| `showAppBottomSheet(context, builder)` | form/tác vụ phụ (drag handle, safe area, tránh bàn phím) |

### Nhóm thành phần thương mại hoá (Commercial EdTech)
| Component | Khi nào dùng |
|---|---|
| `ProBadge(label?, mini?)` | Nhãn tài khoản PRO hoặc tính năng cao cấp (màu vàng kim/vibrant) |
| `StreakBadge(count, active?)` | Huy hiệu chuỗi ngày học liên tục (icon flame + số ngày) |
| `DailyMissionCard(completed, total, tasks, onTap?)` | Thẻ nhiệm vụ duy trì thói quen học tập hôm nay |
| `UpgradeBanner(title, description, onUpgrade, onDismiss?)` | Banner quảng bá nâng cấp Bami PRO tinh tế, không chướng mắt |
| `TestTag(label, isSource?, difficulty?)` | Thẻ tag nguồn đề (ETS 2024) hoặc độ khó (Dễ / Trung bình / Khó) |

---

## 5. Mẫu màn hình chuẩn & Phong cách thương mại

- Nền màn hình xám nhạt (`surfaceContainerLow`), nội dung nằm trong **card trắng viền mảnh** (`AppCard`, `AppListGroup`).
- Màn gốc tab: `AppPageHeader` (kèm `StreakBadge` và `ProBadge`) + 1 `AppHeroCard` (Bento mục tiêu & điểm dự đoán) + `DailyMissionCard` + Section bento.
- Màn con: `AppBar` + nội dung + `AppBottomBar` cho CTA.
- Tuyệt đối không dùng emoji trần thay cho icon hệ thống.
- Chạy golden screenshot: `flutter test --update-goldens test/goldens` trước khi báo hoàn thành UI.
