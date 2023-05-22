// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appUserRepositoryHash() => r'b0d8030725a55df2770d83fe957913eee4672311';

/// See also [appUserRepository].
@ProviderFor(appUserRepository)
final appUserRepositoryProvider = Provider<AppUserRepository>.internal(
  appUserRepository,
  name: r'appUserRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUserRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUserRepositoryRef = ProviderRef<AppUserRepository>;
String _$appUserStreamHash() => r'aa967a129b00ee79c173c7c82513c866de35eb68';

/// See also [appUserStream].
@ProviderFor(appUserStream)
final appUserStreamProvider = AutoDisposeStreamProvider<AppUser?>.internal(
  appUserStream,
  name: r'appUserStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUserStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUserStreamRef = AutoDisposeStreamProviderRef<AppUser?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
