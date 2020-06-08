import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/home_page.dart';
import 'Screens/login_page.dart';
import 'auth_service.dart';
import 'loading_circle.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        create: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      primaryColor: Color(0xff003430),
    accentColor: Color(0xff203A43),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xff203A43),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          height: 45,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          //
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }
            // redirect to the proper page, pass the user into the
            // `HomePage` so we can display the user email in welcome msg
            //print("SnapshotData: " + snapshot.data.email);
            return snapshot.hasData ? HomePage(snapshot.data) : LoginPage();
          } else {
            // show loading indicator
            return LoadingCircle();
          }
        },
      ),
    );
  }
}
