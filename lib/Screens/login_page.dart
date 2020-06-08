import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_with_flutter_tutorial/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset("assets/AppLoginHeader.png"),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 50),
                  child: Column(
                    children: <Widget>[
                      InputField(
                        TextFormField(
                          onSaved: (value) => _email = value,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "E-mail",
                            icon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      InputField(
                        TextFormField(
                          onSaved: (value) => _password = value,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            icon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      FlatButton(
                        textColor: Colors.red,
                        child: Text("Forgot Password?"),
                        onPressed: () {
                          //_auth.signOut();
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("Login"),
                          onPressed: () {
                            showDialog(context: context, child: LoadingCircle());
                            return loginButtonMethod(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text("Login as Guest"),
                          onPressed: () {
                            return loginButtonMethod(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        child: Text("Dont have an account? Sign up here."),
                        textColor: Colors.red,
                        onPressed: () async {
                          final form = _formKey.currentState;
                          form.save();

                          // Validate will return true if is valid, or false if invalid.
                          if (form.validate()) {
                            try {
                              FirebaseUser result =
                                  await Provider.of<AuthService>(context,
                                          listen: false)
                                      .createUser(
                                          firstName: "John",
                                          lastName: "Doe",
                                          email: _email,
                                          password: _password);
                              print(result);
                            } on AuthException catch (error) {
                              // handle the firebase specific error
                              return _buildErrorDialog(context, "Message: " + error.message);
                            } on Exception catch (error) {
                              // gracefully handle anything else that might happen..
                              return _buildErrorDialog(
                                  context, "Error: " + error.toString());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginButtonMethod(BuildContext context) async {
    final form = _formKey.currentState;
    form.save();

    // Validate will return true if is valid, or false if invalid.
    if (form.validate()) {
      try {
        FirebaseUser result =
            await Provider.of<AuthService>(context, listen: false)
                .loginUser(email: _email, password: _password);
        print(result);
      } on AuthException catch (error) {
        // handle the firebase specific error
        return _buildErrorDialog(context, error.message);
      } on Exception catch (error) {
        // gracefully handle anything else that might happen..
        print(error.toString());
        return _buildErrorDialog(
            context, "Something went wrong. Please try again");
      }
    }
  }
}

Future _buildErrorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    },
    context: context,
  );
}

class InputField extends StatelessWidget {
  final TextFormField _textFormField;
  InputField(this._textFormField);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(5)),
        child: _textFormField);
  }
}
