import 'package:flutter/material.dart';

/// Khoảng cách theo lưới 4/8. Dùng cho padding, margin, gap.
abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;

  /// Lề ngang màn hình (Compact). Dùng `AppInsets.screen`.
  static const double screen = s16;

  /// Khoảng trống cuối danh sách để FAB không che item cuối.
  static const double fabClearance = 96;
}

/// EdgeInsets dựng sẵn hay dùng.
abstract final class AppInsets {
  static const screen = EdgeInsets.all(AppSpacing.screen);
  static const screenH = EdgeInsets.symmetric(horizontal: AppSpacing.screen);
  static const card = EdgeInsets.all(AppSpacing.s16);
  static const cardLarge = EdgeInsets.all(AppSpacing.s24);

  /// Chừa chỗ cho FAB ở cuối danh sách.
  static const listBottomForFab = EdgeInsets.only(bottom: AppSpacing.fabClearance);
}

/// Khoảng trống giữa các phần tử trong Column (v) / Row (h).
abstract final class Gaps {
  static const v4 = SizedBox(height: AppSpacing.s4);
  static const v8 = SizedBox(height: AppSpacing.s8);
  static const v12 = SizedBox(height: AppSpacing.s12);
  static const v16 = SizedBox(height: AppSpacing.s16);
  static const v24 = SizedBox(height: AppSpacing.s24);
  static const v32 = SizedBox(height: AppSpacing.s32);
  static const v48 = SizedBox(height: AppSpacing.s48);

  static const h4 = SizedBox(width: AppSpacing.s4);
  static const h8 = SizedBox(width: AppSpacing.s8);
  static const h12 = SizedBox(width: AppSpacing.s12);
  static const h16 = SizedBox(width: AppSpacing.s16);
  static const h24 = SizedBox(width: AppSpacing.s24);
}

/// Bo góc (tinh chỉnh hiện đại, ít bo, sắc nét và cao cấp).
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 999;

  static const brXs = BorderRadius.all(Radius.circular(xs));
  static const brSm = BorderRadius.all(Radius.circular(sm));
  static const brMd = BorderRadius.all(Radius.circular(md));
  static const brLg = BorderRadius.all(Radius.circular(lg));
  static const brXl = BorderRadius.all(Radius.circular(xl));
  static const brFull = BorderRadius.all(Radius.circular(full));
}

/// Kích thước cố định.
abstract final class AppSizes {
  /// Vùng chạm tối thiểu (48dp Android / ≥ 44pt iOS).
  static const double touchTarget = 48;

  /// Chiều cao nút hành động chính (CTA).
  static const double buttonLarge = 52;

  static const double iconXs = 12;
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 56;
  static const double iconHero = 64;

  /// Khối logo trên màn chào / đăng nhập.
  static const double brandMark = 88;

  /// Ô icon nền màu (IconBadge).
  static const double badgeSm = 32;
  static const double badgeMd = 40;
  static const double badgeLg = 48;

  /// Vòng điểm (ScoreRing).
  static const double ringSm = 64;
  static const double ringMd = 96;
  static const double ringLg = 168;
  static const double ringStrokeSm = 6;
  static const double ringStrokeMd = 9;
  static const double ringStrokeLg = 14;

  static const double navBarHeight = 72;

  static const double avatarSm = 28;
  static const double spinnerSm = 20;
  static const double strokeThin = 2;

  static const double progressThin = 3;
  static const double progressThick = 8;

  /// Độ rộng tối đa của nội dung dạng form trên màn lớn.
  static const double formMaxWidth = 400;
  static const double contentMaxWidth = 640;

  /// Ô số câu trong bảng chọn câu / kết quả.
  static const double numberCell = 48;
  static const double numberCellHeight = 40;

  /// Chiều cao placeholder khi ảnh đang tải / lỗi.
  static const double imagePlaceholder = 200;
}

/// Thời lượng & easing (M3 motion tokens). Tôn trọng Reduce Motion qua `AppMotion.of`.
abstract final class AppMotion {
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const long = Duration(milliseconds: 450);
  static const shimmer = Duration(milliseconds: 1200);

  static const standard = Easing.standard;
  static const emphasized = Easing.emphasizedDecelerate;

  /// Trả về [Duration.zero] nếu người dùng bật giảm chuyển động.
  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}
