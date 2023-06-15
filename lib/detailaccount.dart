import 'dart:convert';
//import 'dart:js';
import 'dart:io';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/account.dart';
import 'package:greenhouse_ubaya/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'login.dart';

class DetailAccount extends StatefulWidget {
  String username;
  DetailAccount({super.key, required this.username});
  @override
  DetailAccountState createState() {
    return DetailAccountState();
  }
}

class DetailAccountState extends State<DetailAccount> {
  String namaDepan = "",
      namaBelakang = "",
      email = "",
      jabatan = "",
      _avatar = "";
  int id_jabatan = 0;
  List _jabatan = [];
  User? _account;
  TextEditingController namaLengkapController = TextEditingController();
  TextEditingController namaDepanController = TextEditingController();
  TextEditingController namaBelakangController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController jabatanController = TextEditingController();

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419017/images/account/detailaccount.php"),
        body: {'username': widget.username});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void changeAccount(int change) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419017/images/account/ubahakun.php"),
        body: {
          'username': widget.username,
          'nama_depan': namaDepan,
          'nama_belakang': namaBelakang,
          'email': email,
          'id_jabatan': id_jabatan.toString(),
          'change': change.toString()
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(change == 1
                ? 'Nama Lengkap pengguna telah berhasil diubah'
                : change == 2
                    ? 'Email pengguna telah berhasil diubah'
                    : 'Jabatan pengguna telah berhasil diubah'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 100)));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAccount(username: widget.username),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengubah data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _account = User.fromJson(json['data']);
      setState(() {
        _avatar = _account!.avatar;
        namaDepanController.text = namaDepan = _account!.nama_depan;
        namaBelakangController.text = namaBelakang = _account!.nama_belakang;
        namaLengkapController.text = "$namaDepan $namaBelakang";
        emailController.text = email = _account!.email;
        jabatanController.text = jabatan = _account!.jabatan;
        id_jabatan = _account!.id_jabatan;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
  }

  Widget generateCombo(change) {
    return DropdownSearch<dynamic>(
        dropdownSearchDecoration: InputDecoration(
          hintText: jabatanController.text,
          hintStyle: TextStyle(color: Colors.black),
          labelText: "Daftar Jabatan",
        ),
        mode: Mode.MENU,
        showSearchBox: false,
        onFind: (text) async {
          Map json;
          var response = await http.post(Uri.parse(
              "https://ubaya.fun/flutter/160419017/images/jabatan.php"));

          if (response.statusCode == 200) {
            json = jsonDecode(response.body);
            setState(() {
              _jabatan = json['data'];
            });
          }
          return _jabatan as List<dynamic>;
        },
        onChanged: (value) {
          id_jabatan = value['id'];
          jabatanController.text = value['jabatan'];
        },
        itemAsString: (item) => item['jabatan']);
  }

  void editDialog(int change) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: change == 1
              ? Text("Edit Nama")
              : change == 2
                  ? Text("Edit Email")
                  : Text("Edit Jabatan"),
          content: Container(
              height: 110,
              width: 300,
              child: change == 1
                  ? Column(
                      children: [
                        TextField(
                          controller: namaDepanController,
                          onChanged: (value) {
                            namaDepan = value;
                          },
                          decoration: InputDecoration(
                              label: Text("Nama Depan"),
                              hintText: "Isikan nama depan personil"),
                        ),
                        TextField(
                          controller: namaBelakangController,
                          onChanged: (value) {
                            namaBelakang = value;
                          },
                          decoration: InputDecoration(
                              label: Text("Nama Belakang"),
                              hintText: "Isikan nama belakang personil"),
                        ),
                      ],
                    )
                  : change == 3
                      ? generateCombo(change)
                      : TextField(
                          controller: emailController,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Isikan email personil"),
                        )),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                changeAccount(change);

                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget showPicture() {
    return Column(children: [
      Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(10),
          height: 200,
          width: 150,
          child: Image.network(_avatar)),
      Text("Username:"),
      Text(
        widget.username,
        style: TextStyle(color: Colors.grey),
      )
    ]);
  }

  Widget buildData() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width > 650 ? 440 : 200,
                  child: TextField(
                    enabled: false,
                    controller: namaLengkapController,
                    decoration:
                        const InputDecoration(labelText: 'Nama Lengkap'),
                  )),
              Tooltip(
                child: IconButton(
                    onPressed: () {
                      editDialog(1);
                    },
                    icon: Icon(Icons.edit)),
                message: "Ubah Nama",
              )
            ],
          )),
      Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width > 650 ? 440 : 200,
                  child: TextField(
                    enabled: false,
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  )),
              Tooltip(
                child: IconButton(
                    onPressed: () {
                      editDialog(2);
                    },
                    icon: Icon(Icons.edit)),
                message: "Ubah Email",
              )
            ],
          )),
      Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width > 650 ? 440 : 200,
                  child: TextField(
                    enabled: false,
                    controller: jabatanController,
                    decoration: const InputDecoration(labelText: 'Jabatan'),
                  )),
              Tooltip(
                child: IconButton(
                    onPressed: () {
                      editDialog(3);
                    },
                    icon: Icon(Icons.edit)),
                message: "Ubah jabatan",
              )
            ],
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Pengguna'),
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "home");
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                child: MediaQuery.of(context).size.width > 650
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [showPicture(), buildData()])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [showPicture(), buildData()],
                      ))));
  }
}
