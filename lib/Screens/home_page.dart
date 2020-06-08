import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_with_flutter_tutorial/HomePageDrawer.dart';
import 'package:firebase_with_flutter_tutorial/Screens/show_reservations_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser currentUser;

  HomePage(this.currentUser);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomePageDrawer(widget.currentUser),
        //appBar: MyAppBar("Home"),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        builder: (context) {
                          return Form(
                            key: _formKey,
                            child: AlertDialog(
                              title: Text('Edit Name'),
                              content: TextFormField(
                                onSaved: (value) => _name = value,
                                decoration:
                                    InputDecoration(hintText: 'Full Name'),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                FlatButton(
                                    child: Text('Accept'),
                                    onPressed: () {
                                      final form = _formKey.currentState;
                                      form.save();
                                      print('before');
                                      if (form.validate()) {
                                        UserUpdateInfo info = UserUpdateInfo();
                                        info.displayName = _name;
                                        widget.currentUser.updateProfile(info);
                                        Navigator.of(context).pop();
                                        print('after');
                                      }
                                    }),
                              ],
                            ),
                          );
                        },
                        context: context,
                      );
                    })
              ],
              title: Text('Home'),
              centerTitle: false,
              expandedHeight: 172.3,
              pinned: true,
              backgroundColor: Color(0xff003430),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        child: Image.asset("assets/ProfilHeader.jpg")),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 40.0, bottom: 10),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/LinkedInprofilbillede.jpg'),
                              radius: 50,
                            ),
                          ),
                          Text(
                            widget.currentUser.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        //Text('data'),
                        //ReservationListTile(_doc)
                      ],
                    ),
                  ),
                  Expanded(child: ReservationsList(widget.currentUser, false)),
                  RaisedButton(
                      child: Text('Make new Reservation'), onPressed: () {}),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Platform.isIOS ? Text('iOS Device') : Text('Android Device'),
                  ),
                ],
              ),
              // child: Container(
              //   child: Padding(
              //     padding: EdgeInsets.all(10),
              //     child: Column(
              //       children: <Widget>[
              //         SizedBox(height: 20.0),
              //         RaisedButton(
              //           child: Text("Add Reservation"),
              //           onPressed: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) =>
              //                         ReservationPage(widget.currentUser)));
              //           },
              //         ),
              //         Platform.isIOS
              //             ? Text('iOS Device')
              //             : Text('Android Device'),
              //             ReservationsList(widget.currentUser)
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ],
        ));
  }
}
