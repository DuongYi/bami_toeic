// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Đăng nhập bằng Face ID / Touch ID / vân tay: lưu email + mật khẩu trong Keychain khi người dùng
/// bật, lần sau xác thực sinh trắc rồi đăng nhập bằng thông tin đó. Đăng xuất vẫn giữ để đăng nhập
/// lại nhanh; xoá tài khoản hoặc tắt trong Cài đặt thì xoá.

@ProviderFor(BiometricLogin)
final biometricLoginProvider = BiometricLoginProvider._();

/// Đăng nhập bằng Face ID / Touch ID / vân tay: lưu email + mật khẩu trong Keychain khi người dùng
/// bật, lần sau xác thực sinh trắc rồi đăng nhập bằng thông tin đó. Đăng xuất vẫn giữ để đăng nhập
/// lại nhanh; xoá tài khoản hoặc tắt trong Cài đặt thì xoá.
final class BiometricLoginProvider
    extends $AsyncNotifierProvider<BiometricLogin, BiometricStatus> {
  /// Đăng nhập bằng Face ID / Touch ID / vân tay: lưu email + mật khẩu trong Keychain khi người dùng
  /// bật, lần sau xác thực sinh trắc rồi đăng nhập bằng thông tin đó. Đăng xuất vẫn giữ để đăng nhập
  /// lại nhanh; xoá tài khoản hoặc tắt trong Cài đặt thì xoá.
  BiometricLoginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricLoginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricLoginHash();

  @$internal
  @override
  BiometricLogin create() => BiometricLogin();
}

String _$biometricLoginHash() => r'3b59791da4648de6fefd053277e7c84f991989ac';

/// Đăng nhập bằng Face ID / Touch ID / vân tay: lưu email + mật khẩu trong Keychain khi người dùng
/// bật, lần sau xác thực sinh trắc rồi đăng nhập bằng thông tin đó. Đăng xuất vẫn giữ để đăng nhập
/// lại nhanh; xoá tài khoản hoặc tắt trong Cài đặt thì xoá.

abstract class _$BiometricLogin extends $AsyncNotifier<BiometricStatus> {
  FutureOr<BiometricStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BiometricStatus>, BiometricStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BiometricStatus>, BiometricStatus>,
              AsyncValue<BiometricStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
