import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String _title;
  MyAppBar(this._title);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(
              colors: [Color(0xff0F2027), Color(0xff2C5364)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),),
        ),
        title: Text(_title),
      );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}