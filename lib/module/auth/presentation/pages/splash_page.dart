import 'package:flutter/material.dart';

/// Hiển thị trong lúc khôi phục phiên đăng nhập từ secure storage.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
