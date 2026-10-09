// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Nguồn sự thật duy nhất về trạng thái đăng nhập. `null` = chưa đăng nhập.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Nguồn sự thật duy nhất về trạng thái đăng nhập. `null` = chưa đăng nhập.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, Session?> {
  /// Nguồn sự thật duy nhất về trạng thái đăng nhập. `null` = chưa đăng nhập.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'33af536cdcf6dc924abcbfd5a9b309574477a719';

/// Nguồn sự thật duy nhất về trạng thái đăng nhập. `null` = chưa đăng nhập.

abstract class _$AuthController extends $AsyncNotifier<Session?> {
  FutureOr<Session?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Session?>, Session?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Session?>, Session?>,
              AsyncValue<Session?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// id user hiện tại (dùng khi ghi dữ liệu có cột user_id).

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// id user hiện tại (dùng khi ghi dữ liệu có cột user_id).

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// id user hiện tại (dùng khi ghi dữ liệu có cột user_id).
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'19bc59a05aef430638a24f891b9a8fd6c91b7ea0';
