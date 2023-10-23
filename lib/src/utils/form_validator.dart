import 'package:flutter/material.dart';

// from validator that validates a form and return a booloean.
// unit test is not necessary because testing a built-in methods is redandunt

bool formIsValid(FormState form) {
  if (form.validate()) {
    form.save();
    return true;
  } else {
    return false;
  }
}
