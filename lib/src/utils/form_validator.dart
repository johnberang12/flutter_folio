import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_validator.g.dart';

// from validator that validates a form and return a booloean.
// unit test is not necessary because testing a built-in methods is redandunt

@riverpod
bool formValidator(FormValidatorRef ref, FormState form) {
  if (form.validate()) {
    form.save();
    return true;
  } else {
    return false;
  }
}
