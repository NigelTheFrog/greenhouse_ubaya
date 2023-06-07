import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAccount extends StatefulWidget {
  CreateAccount({Key? key}) : super(key: key);
  @override
  CreateAccountState createState() {
    return CreateAccountState();
  }
}

class CreateAccountState extends State<CreateAccount> {
  String username = "",
      email = "",
      nama_depan = "",
      nama_belakang = "",
      password = "",
      avatar = "",
      error_create = "";
  int id_jabatan = 0;
  List jabatan = [];

  void submit(BuildContext context) async {
    final response = await http.post(
        Uri.parse("http://192.168.137.1/tugas_akhir/account/createaccount.php"),
        body: {
          'username': username,
          'email': email,
          'nama_depan': nama_depan,
          'nama_belakang': nama_belakang,
          'password': password,
          'avatar': avatar,
          'jabatan': id_jabatan.toString()
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Container(
                height: 70,
                width: 300,
                child: Text("Data $username berhasil ditambahkan")),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "home");
                },
              ),
            ],
          );
        },
      );
      } else if (json['Error'] ==
          "Duplicate entry '$username' for key 'PRIMARY'") {
        setState(() {
          error_create = "Pengguna telah didaftarkan";
        });
      } else {
        setState(() {
          error_create = "Perbaiki pengisian";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void resultDialog() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Pengguna"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Container(
                    width: 500,
                    alignment: Alignment.center,
                    child: Column(children: [
                      Text("ISIKAN DATA DIRI PENGGUNA YANG HENDAK DIDAFTARKAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          textAlign: TextAlign.center),
                      Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 200,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Image.network(
                            avatar,
                            errorBuilder: (context, error, stackTrace) {
                              return Text("Data pengguna tidak ditemukan",
                                  textAlign: TextAlign.center);
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.topCenter,
                              width: 280,
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                onChanged: (value) {
                                  username = value;
                                },
                                decoration: const InputDecoration(
                                    label: Text("Username"),
                                    hintText: 'Isikan NRP / NPK pengguna'),
                              )),
                          Tooltip(
                              message: "Cek Akun",
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (username.contains("s")) {
                                        avatar =
                                            "https://my.ubaya.ac.id/img/mhs/${username.substring(1)}_m.jpg";
                                        email = "$username@student.ubaya.ac.id";
                                      } else {
                                        avatar =
                                            "https://my.ubaya.ac.id/img/krywn/${username}_l.jpg";
                                        email = "$username@staff.ubaya.ac.id";
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.refresh)))
                        ],
                      ),
                      Container(
                          alignment: Alignment.topCenter,
                          width: 300,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: const InputDecoration(
                                label: Text("Password"),
                                hintText: 'Isikan password pengguna'),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.topCenter,
                                width: 150,
                                padding: EdgeInsets.only(
                                    right: 5, top: 10, bottom: 10),
                                child: TextField(
                                  onChanged: (value) {
                                    nama_depan = value;
                                  },
                                  decoration: const InputDecoration(
                                      label: Text("Nama Depan"),
                                      hintText: 'Isikan nama depan pengguna',
                                      hintStyle: TextStyle(fontSize: 10)),
                                )),
                            Container(
                                alignment: Alignment.topCenter,
                                width: 150,
                                padding: EdgeInsets.only(
                                    left: 5, top: 10, bottom: 10),
                                child: TextField(
                                  onChanged: (value) {
                                    nama_belakang = value;
                                  },
                                  decoration: const InputDecoration(
                                      label: Text("Nama Belakang"),
                                      hintText: 'Isikan nama belakang pengguna',
                                      hintStyle: TextStyle(fontSize: 10)),
                                )),
                          ]),
                      Container(
                          alignment: Alignment.topCenter,
                          width: 300,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: DropdownSearch<dynamic>(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Daftar Jabatan",
                              labelText: "Jabatan",
                            ),
                            mode: Mode.MENU,
                            onFind: (text) async {
                              Map json;
                              var response = await http.post(
                                  Uri.parse(
                                      "http://192.168.137.1/tugas_akhir/jabatan.php"),
                                  body: {'cari': text});

                              if (response.statusCode == 200) {
                                json = jsonDecode(response.body);
                                setState(() {
                                  jabatan = json['data'];
                                });
                              }
                              return jabatan as List<dynamic>;
                            },
                            onChanged: (value) {
                              setState(() {
                                id_jabatan = value['id'];
                              });
                            },
                            itemAsString: (item) => item['jabatan'],
                          )),
                      if (error_create != "")
                        Text(error_create,
                            style: const TextStyle(color: Colors.red)),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  submit(context);
                                });
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )),
                    ])))));
  }
}
