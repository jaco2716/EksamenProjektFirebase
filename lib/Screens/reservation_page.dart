import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_with_flutter_tutorial/MyAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class ReservationPage extends StatelessWidget {
  final FirebaseUser currentUser;
  ReservationPage(this.currentUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("Make Reservation"),
      body: SingleChildScrollView(child: ReservationColumn(currentUser)),
    );
  }
}

class ReservationColumn extends StatefulWidget {
  final FirebaseUser currentUser;
  ReservationColumn(this.currentUser);

  @override
  _ReservationColumnState createState() => _ReservationColumnState();
}

class _ReservationColumnState extends State<ReservationColumn> {
  final Firestore _firestore = Firestore.instance;
  final List<String> chosenServices = List<String>();
  final List<String> chosenLocation = List<String>();
  DateTime selectedDate;
  TimeOfDay selectedTime;
  DateTime _initDate = DateTime.now();
  String _timeButtonText = 'Vælg Tidspunkt';
  String _dateButtonText = 'Vælg Dato';
  bool hasPaid = false;
  String contactNr;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TitleTile("Vælg Service"),
              ServiceListTile("1 Session", "Session for 1 person, 45-60 min.",
                  "1600,00kr.", chosenServices),
              ServiceListTile("1 Par session", "Session for par, 45-60 min.",
                  "2700,00kr.", chosenServices),
              ServiceListTile("Gavekort", "Gavekort til 1 person.",
                  "1600,00kr.", chosenServices),
              ServiceListTile("1 Session via Telefon/Skype",
                  "Skal betales med det samme", "1600,00kr.", chosenServices),
              TitleTile("Vælg Lokation"),
              LocationListTile(
                  "Bille", "København", Icon(Icons.person), chosenLocation),
              TitleTile("Vælg Tidspunkt"),
              Platform.isIOS
                  ? CupertinoDatePicker(
                      initialDateTime: _initDate,
                      onDateTimeChanged: (dateTime) {
                        print(dateTime);
                        setState(() {
                          _initDate = dateTime;
                        });
                      })
                  : Row(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: OutlineButton(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            onPressed: () async {
                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2030),
                              );
                              setState(() {
                                _dateButtonText = selectedDate.day.toString() +
                                    " - " +
                                    selectedDate.month.toString() +
                                    " - " +
                                    selectedDate.year.toString();
                              });
                            },
                            child: Text(_dateButtonText),
                          ),
                        ),
                        Expanded(
                          child: OutlineButton(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            onPressed: () async {
                              selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              setState(() {
                                _timeButtonText = selectedTime.hour.toString() +
                                    " : " +
                                    selectedTime.minute.toString();
                              });
                            },
                            child: Text(_timeButtonText),
                          ),
                        ),
                      ],
                    ),
              TitleTile("Kontaktoplysninger"),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  onSaved: (value) => contactNr = value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone Number",
                    icon: Icon(Icons.phone),
                  ),
                ),
              ),
              CheckboxListTile(
                  secondary: Icon(Icons.payment),
                  title: Text("Pay"),
                  value: hasPaid,
                  onChanged: (bool value) {
                    setState(() {
                      hasPaid = value;
                    });
                  }),
              RaisedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    final form = _formKey.currentState;
                    form.save();

                    if (selectedDate != null &&
                        selectedTime != null &&
                        contactNr != null &&
                        chosenLocation.length > 0 &&
                        chosenServices.length > 0) {
                      // String finalDate = selectedDate.year.toString() +
                      //     '-' +
                      //     selectedDate.month.toString() +
                      //     '-' +
                      //     selectedDate.day.toString() +
                      //     ' ' +
                      //     selectedTime.hour.toString() +
                      //     ':' +
                      //     selectedTime.minute.toString();
                      // print("FinalDate: " + finalDate);
                      DateTime finalDate = selectedDate.add(Duration(
                          hours: selectedTime.hour,
                          minutes: selectedTime.minute));

                      print('time: ' + selectedTime.toString());
                      print('date: ' + finalDate.toString());

                      await _firestore
                          .collection('users')
                          .document(widget.currentUser.uid)
                          .collection('reservations')
                          .add({
                        'time': finalDate,
                        'location': chosenLocation,
                        'type': chosenServices,
                        'paid': hasPaid,
                        'contactNr': contactNr,
                      });
                      print("Saved to Firestore");
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all fields.")));
                    }
                  }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TitleTile extends StatelessWidget {
  final String _title;
  TitleTile(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.blueGrey[900],
      width: double.infinity,
      child: Text(
        _title,
        style: TextStyle(fontSize: 30, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class LocationListTile extends StatefulWidget {
  final String _title;
  final String _subtitle;
  final Icon _secondary;
  final List<String> _chosenLocation;
  LocationListTile(
      this._title, this._subtitle, this._secondary, this._chosenLocation);

  @override
  _LocationListTileState createState() => _LocationListTileState();
}

class _LocationListTileState extends State<LocationListTile> {
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
        secondary: widget._secondary,
        title: Text(widget._title),
        subtitle: Text(widget._subtitle),
        value: _checkboxValue,
        onChanged: (bool value) {
          setState(() {
            _checkboxValue = value ? true : false;
            if (_checkboxValue) {
              widget._chosenLocation.add(widget._subtitle);
            } else {
              widget._chosenLocation.remove(widget._title);
            }
          });
        },
      ),
    );
  }
}

class ServiceListTile extends StatefulWidget {
  final String _title;
  final String _subtitle;
  final String _secondary;
  final List<String> _chosenServices;

  ServiceListTile(
      this._title, this._subtitle, this._secondary, this._chosenServices);

  @override
  _ServiceListTileState createState() => _ServiceListTileState();
}

class _ServiceListTileState extends State<ServiceListTile> {
  bool _checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _checkboxValue,
      title: Text(widget._title),
      subtitle: Text(widget._subtitle),
      secondary: Text(
        widget._secondary,
        style: TextStyle(color: Colors.green),
      ),
      onChanged: (bool value) {
        setState(() {
          _checkboxValue = value ? true : false;
          if (_checkboxValue) {
            widget._chosenServices.add(widget._title);
          } else {
            widget._chosenServices.remove(widget._title);
          }
          print(widget._chosenServices.toString());
        });
      },
    );
  }
}
