import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_with_flutter_tutorial/Screens/reservation_page.dart';
import 'package:firebase_with_flutter_tutorial/Screens/show_reservations_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class HomePageDrawer extends StatelessWidget {
  final FirebaseUser currentUser;
  HomePageDrawer(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/LinkedInprofilbillede.jpg'),),
            accountEmail: Text(currentUser.email),
            accountName: Text(currentUser.displayName != null
                ? currentUser.displayName
                : currentUser.email.split("@")[0]),
          ),
          DrawerListTile(Icon(Icons.person), "Show Reservations", ShowReservationsPage(currentUser)),
          Divider(),
          DrawerListTile(
              Icon(Icons.keyboard), "Reservation Page", ReservationPage(currentUser)),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text("Logout"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              Navigator.pop(context);
              await Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final Icon _tileIcon;
  final String _tileTitle;
  final Widget _navigationPage;
  DrawerListTile(this._tileIcon, this._tileTitle, this._navigationPage);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: _tileIcon,
        title: Text(_tileTitle),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => _navigationPage));
        });
  }
}
