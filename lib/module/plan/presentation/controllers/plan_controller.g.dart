// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gói của user đang đăng nhập; tự tải lại khi đổi tài khoản.

@ProviderFor(myPlan)
final myPlanProvider = MyPlanProvider._();

/// Gói của user đang đăng nhập; tự tải lại khi đổi tài khoản.

final class MyPlanProvider
    extends $FunctionalProvider<AsyncValue<MyPlan>, MyPlan, FutureOr<MyPlan>>
    with $FutureModifier<MyPlan>, $FutureProvider<MyPlan> {
  /// Gói của user đang đăng nhập; tự tải lại khi đổi tài khoản.
  MyPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPlanProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPlanHash();

  @$internal
  @override
  $FutureProviderElement<MyPlan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MyPlan> create(Ref ref) {
    return myPlan(ref);
  }
}

String _$myPlanHash() => r'57f8f194a761cd1de306e197488463d485aa9489';

@ProviderFor(adminUsers)
final adminUsersProvider = AdminUsersFamily._();

final class AdminUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminUser>>,
          List<AdminUser>,
          FutureOr<List<AdminUser>>
        >
    with $FutureModifier<List<AdminUser>>, $FutureProvider<List<AdminUser>> {
  AdminUsersProvider._({
    required AdminUsersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminUsersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminUsersHash();

  @override
  String toString() {
    return r'adminUsersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdminUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminUser>> create(Ref ref) {
    final argument = this.argument as String;
    return adminUsers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminUsersHash() => r'f85410383ff72c48093043a691daa3c0a6e730c1';

final class AdminUsersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AdminUser>>, String> {
  AdminUsersFamily._()
    : super(
        retry: null,
        name: r'adminUsersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminUsersProvider call(String query) =>
      AdminUsersProvider._(argument: query, from: this);

  @override
  String toString() => r'adminUsersProvider';
}
