// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_validator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$formValidatorHash() => r'bc4a5b798ef0b7011eff1acb8d59f71be5282a6d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef FormValidatorRef = AutoDisposeProviderRef<bool>;

/// See also [formValidator].
@ProviderFor(formValidator)
const formValidatorProvider = FormValidatorFamily();

/// See also [formValidator].
class FormValidatorFamily extends Family<bool> {
  /// See also [formValidator].
  const FormValidatorFamily();

  /// See also [formValidator].
  FormValidatorProvider call(
    FormState form,
  ) {
    return FormValidatorProvider(
      form,
    );
  }

  @override
  FormValidatorProvider getProviderOverride(
    covariant FormValidatorProvider provider,
  ) {
    return call(
      provider.form,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'formValidatorProvider';
}

/// See also [formValidator].
class FormValidatorProvider extends AutoDisposeProvider<bool> {
  /// See also [formValidator].
  FormValidatorProvider(
    this.form,
  ) : super.internal(
          (ref) => formValidator(
            ref,
            form,
          ),
          from: formValidatorProvider,
          name: r'formValidatorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$formValidatorHash,
          dependencies: FormValidatorFamily._dependencies,
          allTransitiveDependencies:
              FormValidatorFamily._allTransitiveDependencies,
        );

  final FormState form;

  @override
  bool operator ==(Object other) {
    return other is FormValidatorProvider && other.form == form;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, form.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
