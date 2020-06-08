import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_with_flutter_tutorial/Model/Reservation.dart';
import 'package:firebase_with_flutter_tutorial/MyAppBar.dart';
import 'package:flutter/material.dart';

class ShowReservationsPage extends StatelessWidget {
  final FirebaseUser currentUser;

  const ShowReservationsPage(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("Show Reservations"),
      body: ReservationsList(currentUser, true),
    );
  }
}

class ReservationsList extends StatelessWidget {
  final FirebaseUser currentUser;
  final bool _scrollable;

  ReservationsList(this.currentUser, this._scrollable);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(currentUser.uid)
            .collection('reservations')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Text("You have no reservations");
          else if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              final int dataCount = snapshot.data.documents.length;
              return ListView.builder(
                physics: _scrollable
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                itemCount: dataCount,
                itemBuilder: (_, int index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];
                  return ReservationListTile(document);
                },
              );
          }
        });
  }

  
}

class ReservationListTile extends StatelessWidget {
  final DocumentSnapshot _doc; 


  ReservationListTile(this._doc);

  @override
  Widget build(BuildContext context) {

    var reservation = Reservation.fromJson(_doc.data);
    DateTime _myDate = DateTime.fromMillisecondsSinceEpoch(
        reservation.time.millisecondsSinceEpoch);
    List<String> _timeStringArray = _myDate.toString().split(':');
    String _myDateString = '${_timeStringArray[0]} ${_timeStringArray[1]}';
    print('Datestring: ' + _myDateString);

    return Card(
      child: ListTile(
          trailing: IconButton(
            onPressed: () => _doc.reference.delete(),
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          onTap: () {},
          leading: CircleAvatar(
            foregroundColor: Colors.white,
            radius: 30,
            child: Text(
              reservation.location[0][0],
              //location[0][0],
            ),
            backgroundColor: reservation.paid ? Colors.green : Colors.pink,
          ),
          title: Text(
              reservation.type.length == 1
                  ? listToString(reservation.type)
                  : reservation.type.length.toString() + ' Reservations',
              style: TextStyle(
                  color: reservation.paid ? Colors.green : Colors.pink)),
          subtitle: Text(_myDateString)),
    ); 
  }

  listToString(List<dynamic> list) {
    String item = '';
    for (var name in list) {
      item = item + name + ', ';
    }
    return item;
  }
}
