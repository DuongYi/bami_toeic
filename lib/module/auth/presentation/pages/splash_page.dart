import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';

/// Hiển thị dạng skeleton trong lúc khôi phục phiên đăng nhập từ secure storage.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashSkeleton();
  }
}
