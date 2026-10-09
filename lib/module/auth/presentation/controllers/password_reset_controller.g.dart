// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Trạng thái gửi mã / đặt lại mật khẩu (loading / lỗi) của màn Quên mật khẩu.

@ProviderFor(PasswordResetController)
final passwordResetControllerProvider = PasswordResetControllerProvider._();

/// Trạng thái gửi mã / đặt lại mật khẩu (loading / lỗi) của màn Quên mật khẩu.
final class PasswordResetControllerProvider
    extends $AsyncNotifierProvider<PasswordResetController, void> {
  /// Trạng thái gửi mã / đặt lại mật khẩu (loading / lỗi) của màn Quên mật khẩu.
  PasswordResetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordResetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordResetControllerHash();

  @$internal
  @override
  PasswordResetController create() => PasswordResetController();
}

String _$passwordResetControllerHash() =>
    r'8faf03c7b50d4d9cccf8ea6de91b3a18ef09ad17';

/// Trạng thái gửi mã / đặt lại mật khẩu (loading / lỗi) của màn Quên mật khẩu.

abstract class _$PasswordResetController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
