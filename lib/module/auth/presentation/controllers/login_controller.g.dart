// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Trạng thái gửi form đăng nhập (loading / lỗi).

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// Trạng thái gửi form đăng nhập (loading / lỗi).
final class LoginControllerProvider extends $AsyncNotifierProvider<LoginController, void> {
  /// Trạng thái gửi form đăng nhập (loading / lỗi).
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'70811cd9cf1f9fbbb8fefc16c9608b8d30708db4';

/// Trạng thái gửi form đăng nhập (loading / lỗi).

abstract class _$LoginController extends $AsyncNotifier<void> {
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
