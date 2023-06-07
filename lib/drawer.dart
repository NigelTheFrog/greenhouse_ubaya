import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

String active_user = "",
    email = "",
    nama_depan = "",
    nama_belakang = "",
    avatar = "",
    id_jabatan = "";

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (nama_depan != prefs.getString("nama_depan") ||
        nama_belakang != prefs.getString("nama_belakang") ||
        email != prefs.getString("email") ||
        avatar != prefs.getString("avatar") ||
        id_jabatan != prefs.getString("jabatan_id")) {
      setState(() {
        nama_depan = prefs.getString("nama_depan") ?? '';
        nama_belakang = prefs.getString("nama_belakang") ?? '';
        email = prefs.getString("email") ?? '';
        avatar = prefs.getString("avatar") ?? '';
        id_jabatan = prefs.getString("jabatan_id") ?? '';
      });
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _loadData();
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 16.0,
        child: Column(children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                    accountEmail: Text(email),
                    accountName: Text("$nama_depan $nama_belakang"),
                    currentAccountPicture:
                        CircleAvatar(backgroundImage: NetworkImage(avatar))),
                ListTile(
                  title: const Text("Home"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.popAndPushNamed(context, "home");
                  },
                ),
                ListTile(
                  title: const Text("Account"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/account");
                  },
                ),
                ListTile(
                  title: const Text("Logout"),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    doLogout();
                  },
                ),
              ],
            ),
          )
        ]));
  }
}
