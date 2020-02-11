import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validation_example/blocs/events/form_screen_event.dart';
import 'package:validation_example/blocs/form_screen_bloc.dart';
import 'package:validation_example/blocs/states/form_screen_state.dart';
import 'package:validation_example/models/enums/field_error.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  FormScreenBloc _bloc;

  final _emailController = TextEditingController();

  @override
  void initState() {
    this._bloc = FormScreenBloc();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormScreenBloc, FormScreenState>(
      bloc: this._bloc,
      listener: (context, state) {
        if (state.submissionSuccess) {
          showDialog(
            context: context,
            child: AlertDialog(
                title: Text('Submission success!'),
                content: Text("Your submission was a success"),
                actions: [
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ]),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: BlocBuilder<FormScreenBloc, FormScreenState>(
                bloc: this._bloc,
                builder: (context, state) {
                  if (state.isBusy) {
                    return CircularProgressIndicator();
                  }

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: this._emailController,
                          style: TextStyle(
                            color: this._hasEmailError(state)
                                ? Colors.red
                                : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelStyle: TextStyle(
                              color: this._hasEmailError(state)
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            hintStyle: TextStyle(
                              color: this._hasEmailError(state)
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            enabledBorder: this._renderBorder(state),
                            focusedBorder: this._renderBorder(state),
                          ),
                        ),
                        if (this._hasEmailError(state)) ...[
                          SizedBox(height: 5),
                          Text(
                            this._emailErrorText(state.emailError),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                        SizedBox(height: 30),
                        RaisedButton(
                          child: Text('Submit'),
                          onPressed: () => this._bloc.add(FormScreenEventSubmit(
                              this._emailController.text)),
                        ),
                      ]);
                }),
          ),
        ),
      ),
    );
  }

  UnderlineInputBorder _renderBorder(FormScreenState state) =>
      UnderlineInputBorder(
        borderSide: BorderSide(
            color: this._hasEmailError(state) ? Colors.red : Colors.black,
            width: 1),
      );

  bool _hasEmailError(FormScreenState state) => state.emailError != null;

  String _emailErrorText(FieldError error) {
    switch (error) {
      case FieldError.Empty:
        return 'You need to enter an email address';
      case FieldError.Invalid:
        return 'Email address invalid';
      default:
        return '';
    }
  }
}
