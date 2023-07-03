import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/account.dart';
import 'package:greenhouse_ubaya/detailaccount.dart';
import 'package:greenhouse_ubaya/drawer.dart';
import 'package:http/http.dart' as http;

class AccountList extends StatefulWidget {
  int status;
  AccountList({super.key, required this.status});
  @override
  State<StatefulWidget> createState() {
    return _AccountListState();
  }
}

class _AccountListState extends State<AccountList> {
  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse(
          "https://ubaya.fun/native/160419026/tugas_akhir/account/daftaraccount.php"),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget daftarsensor(data) {
    List<User> account2 = [];
    Map json = jsonDecode(data);
    for (var mov in json['data']) {
      User account = User.fromJson(mov);
      account2.add(account);
    }
    return ListView.builder(
        itemCount: account2.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailAccount(
                              username: account2[index].username,
                            ),
                          ),
                        );
                      },
                      child: Card(
                          child: SizedBox(
                        width: 800,
                        height: 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 10),
                                      height: 85,
                                      width: 75,
                                      child: Image.network(
                                          fit: BoxFit.fill,
                                          account2[index].avatar)),
                                  Padding(
                                    padding: EdgeInsets.only(left: 50),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            account2[index].username,
                                            style:
                                                TextStyle(color: Colors.grey),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "${account2[index].nama_depan} ${account2[index].nama_belakang}",
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Jabatan: ",
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        account2[index].jabatan,
                                      ),
                                    ]),
                              )
                            ]),
                      )))
                ],
              ),
            ),
          );
        });
  }

  Widget buildContainer() {
    return ListView(children: <Widget>[
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: 600,
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return daftarsensor(snapshot.data.toString());
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 0) {
      return Scaffold(
          body: buildContainer(),
          floatingActionButton: Tooltip(
            message: "Daftar Akun",
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.popAndPushNamed(context, "/createaccount");
              },
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(title: Text("Daftar Akun")),
          drawer: MyDrawer(),
          body: buildContainer(),
          floatingActionButton: Tooltip(
            message: "Halaman Tambah Pengguna",
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.popAndPushNamed(context, "/createaccount");
              },
            ),
          ));
    }
  }
}
