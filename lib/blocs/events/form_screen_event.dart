abstract class FormScreenEvent {}

class FormScreenEventSubmit extends FormScreenEvent {
  final String email;
  FormScreenEventSubmit(this.email);
}
