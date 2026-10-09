---
name: bami-ui-ux-pro
description: "Tiêu chuẩn kỹ thuật UI/UX di động chuyên nghiệp và chống AI-slop cho app Flutter Bami TOEIC. Tổng hợp tinh hoa từ anti-slop-design, mobile-design, ui-ux-pro-max và design-spells. BẮT BUỘC áp dụng khi thiết kế mới, tái cấu trúc hoặc làm đẹp bất kỳ màn hình nào của Bami TOEIC."
---

# Bami UI/UX Pro — Tiêu Chuẩn Thiết Kế & Chống AI-Slop Cho Flutter

> **Triết lý:** Mobile-first · Touch-first · Không generic slop · Tinh tế chuẩn thương mại hoá.  
> **Nguyên tắc vàng:** "Mobile không phải desktop thu nhỏ. AI code không được dùng style khuôn mẫu."

Skill này được đúc kết từ các tiêu chuẩn hàng đầu trong thư viện `agentic-awesome-skills` (`anti-slop-design`, `mobile-design`, `ui-ux-pro-max`, `design-spells`) và được tùy biến riêng cho kiến trúc Flutter của **Bami TOEIC**.

---

## 1. Ma Trận Cấm Tuyệt Đối (Anti-Slop Banned Matrix)

Tuyệt đối cấm các lỗi sinh code phổ biến của AI sau đây trong Bami TOEIC:

| Lỗi AI Slop Thường Gặp | Biểu hiện sai | Thay thế bắt buộc trong Bami TOEIC |
| :--- | :--- | :--- |
| **Dùng Emoji làm Icon** | Đặt `🔥`, `🚀`, `💡`, `🎯` trực tiếp trong Text | Dùng `Icon(Icons.*)` hoặc component chuyên dụng (`StreakBadge`, `ProBadge`, `IconBadge`) |
| **Card rập khuôn 3 cột** | 3 khối chữ nhật giống hệt nhau xếp hàng | Bố cục **Bento Grid** linh hoạt, phân cấp chính/phụ theo tần suất sử dụng |
| **Nhãn in hoa gắt gỏng** | `OVERVIEW`, `STATS`, `FEATURES` all-caps | `SectionHeader(title: 'Tổng quan')` chuẩn Sentence-case tiếng Việt |
| **Thiếu trạng thái tương tác** | Chỉ có 1 trạng thái tĩnh, bấm không có phản hồi | Hệ thống phản hồi xúc giác: ripple, scale nhẹ, `InkWell`/`InkResponse` đạt chuẩn |
| **Số liệu giả vô nghĩa** | Đặt các số liệu không có thật để lấp đầy giao diện | Chỉ hiển thị dữ liệu thật từ Supabase/Riverpod; nếu chưa có thì hiển thị Empty state kèm hành động |
| **Hard-code màu & kích thước** | `Color(0xFF...)`, `fontSize: 16`, `SizedBox(height: 20)` | **Bắt buộc dùng token** trong `lib/core/design_system/`: `context.colors`, `AppSpacing`, `Gaps`, `context.textStyles` |
| **Nút bấm quá nhỏ** | Vùng chạm < 44dp gây bấm trượt trên điện thoại | Mọi phần tử tương tác phải đạt tối thiểu **48x48dp** (`AppSizes.touchTarget`) |
| **Màn hình con thiếu thanh đáy CTA** | Để nút hành động quan trọng tít trên đỉnh | Đặt nút hành động chính trong `AppBottomBar` ở vùng ngón tay cái dễ chạm nhất |

---

## 2. Các Tiên Đề UX Thương Mại Hoá (Commercial UX Axioms)

### Tiên đề 1: Quy tắc "1-đến-3" (Triangle of Focus)
Mỗi màn hình hoặc cụm thẻ (Card/Bento) chỉ được có:
- **1 Hành động / Phần tử chính** (Primary Action / Hero Focal Anchor).
- **Tối đa 3 thông tin bổ trợ** (Metadata, chip trạng thái, lối tắt phụ).
- *Kiểm tra:* Không nhét 5 nút bấm ngang hàng vào cùng 1 card.

### Tiên đề 2: Quy luật 85% Tần suất Thực tế (85% Statistical Prioritization)
- 85% nhu cầu của người học TOEIC khi mở app là: **Làm tiếp bài dở**, **Luyện Part đang yếu**, **Ôn từ vựng đến hạn** hoặc **Xem giải thích câu sai**.
- Các thao tác này phải có mặt ngay tại màn hình chính với **1 cú chạm (Zero-click to start)**.
- Các chức năng cấu hình ít dùng (đổi mật khẩu, xem điều khoản) thu gọn vào BottomSheet tài khoản.

### Tiên đề 3: Nhất quán Nguồn Thống kê (Single Source of Truth)
- Không lặp lại cùng một chỉ số điểm ở 3 chỗ khác nhau trên cùng một tầm mắt.
- Một chỉ số chính (ví dụ: Điểm TOEIC dự đoán) chiếm vị trí trung tâm trong `AppHeroCard`, các phân tích chi tiết nằm ở bảng bên dưới.

---

## 3. Công Thái Học Di Động (Thumb Zone & Ergonomics)

```
        ┌─────────────────────────┐
        │  [AppBar / Tên màn]     │  <- Vùng khó chạm (chỉ hiển thị thông tin)
        ├─────────────────────────┤
        │                         │
        │    [Nội dung đọc /]     │  <- Vùng vươn ngón tay
        │    [Câu hỏi đề thi]     │
        │                         │
        ├─────────────────────────┤
        │  [Bento Quick Actions]  │  <- Vùng ngón tay cái tự nhiên (Natural Thumb Zone)
        │  [Đáp án A, B, C, D]   │  <- Đặt mọi tương tác tần suất cao tại đây
        ├─────────────────────────┤
        │  [AppBottomBar: CTA]    │  <- Vị trí chuẩn cho nút "Nộp bài", "Tiếp tục"
        └─────────────────────────┘
```

1. **Chiều cao nút CTA chính**: Tối thiểu `AppSizes.buttonLarge` (52dp) hoặc trong `AppBottomBar`.
2. **Khoảng cách phím**: Giữa các đáp án hoặc các lựa chọn trong form, dùng `Gaps.v12` hoặc `Gaps.v16`.
3. **Tránh bàn phím che**: Sử dụng `SingleChildScrollView(keyboardDismissBehavior: onDrag)` và `showAppBottomSheet` tự co giãn khi bàn phím xuất hiện.

---

## 4. Chi Tiết "Design Spells" (Micro-interactions & Độ Tinh Xảo)

1. **Vòng điểm số (ScoreRing)**: Có hoạt ảnh quét tiến độ mượt mà từ 0 đến giá trị thực tế.
2. **Thẻ Hero**: Nền gradient chuyển màu nhẹ (`surfaces.hero`), chữ tương phản cao tuyệt đối (`surfaces.onHero`).
3. **Phản hồi khi chạm**: `InkWell` hoặc `InkResponse` có bo góc đồng bộ với card (`AppRadius.brLg`), màu ripple lấy theo `colors.primary.withValues(alpha: 0.1)`.
4. **Huy hiệu & Điểm thưởng**: Thể hiện chuỗi ngày học (`StreakBadge`), hạng thành viên (`ProBadge`), mức độ đề thi (`TestTag`).

---

## 5. Quy Trình Kiểm Thử Bắt Buộc Trước Khi Commit UI

```bash
# 1. Kiểm tra không có lỗi cú pháp hoặc deprecation
flutter analyze

# 2. Kiểm tra bộ quy tắc design system không bị vi phạm (CẤM HARDCODE)
flutter test test/design_system_lint_test.dart

# 3. Kiểm tra độ tương phản màu chuẩn WCAG AA và vùng chạm tối thiểu 48dp
flutter test test/design_system_widget_test.dart

# 4. Cập nhật ảnh golden test chụp các màn hình
flutter test --update-goldens test/goldens
```
