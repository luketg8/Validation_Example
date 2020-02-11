import 'package:validation_example/models/enums/field_error.dart';

class FormScreenState {
  final bool isBusy;
  final FieldError emailError;
  final bool submissionSuccess;
  FormScreenState({
    this.isBusy: false,
    this.emailError,
    this.submissionSuccess,
  });
}
