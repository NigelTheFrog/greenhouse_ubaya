import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/raspberry.dart';
import 'package:greenhouse_ubaya/detailraspi.dart';
import 'package:greenhouse_ubaya/drawer.dart';
import 'package:greenhouse_ubaya/sensorlist.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String raspberry_id = "", jabatan_id = "";

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Future<String> fetchData() async {
    final response = await http
        .get(Uri.parse("https://ubaya.fun/native/160419026/tugas_akhir/raspberrylist.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jabatan_id = prefs.getString("jabatan_id") ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  List<Widget> raspberryList(BuildContext context, data) {
    List<Widget> temp = [];
    List<Raspbbery> raspberry2 = [];
    Map json = jsonDecode(data);
    Widget w = Text("");
    if (json['result'] == "error") {
      w = Text("");
    } else {
      for (var pers in json['data']) {
        Raspbbery raspbbery = Raspbbery.fromJson(pers);
        raspberry2.add(raspbbery);
      }
      for (int i = 0; i < raspberry2.length; i++) {
        w = SizedBox(
          width: 300,
          height: 300,
          child: GestureDetector(
              onTap: () {
                if (jabatan_id == "1" || jabatan_id == "2") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailRaspi(raspberry_id: raspberry2[i].id),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SensorList(raspberry_id: raspberry2[i].id),
                    ),
                  );
                }
              },
              child: Card(
                  child: Column(
                children: [
                  Container(
                      width: 300,
                      height: 200,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: raspberry2[i].tipe == "Raspberry Pi 3"
                            ? AssetImage("assets/images/raspberry-pi-3.jpg")
                            : raspberry2[i].tipe == "Raspberry Pi 3b"
                                ? AssetImage(
                                    "assets/images/raspberry-pi-3b.jpg")
                                : raspberry2[i].tipe == "Raspberry Pi 3b+"
                                    ? AssetImage(
                                        "assets/images/raspberry-pi-3b+.jpg")
                                    : AssetImage(
                                        "assets/images/raspberry-pi-4.jpg"),
                        fit: BoxFit.fill,
                        // alignment: Alignment.topCenter,
                      ))),
                  Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 105, 105, 105),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "id: " + raspberry2[i].id,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(raspberry2[i].tipe,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Row(children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Color.fromARGB(255, 95, 95, 95),
                    ),
                    Text(raspberry2[i].lokasi,
                        style:
                            TextStyle(color: Color.fromARGB(255, 95, 95, 95)))
                  ])
                ],
              ))),
        );
        temp.add(w);
      }
    }
    return temp;
  }

  Widget raspbberyMobileList(data) {
    List<Raspbbery> raspbbery2 = [];
    Map json = jsonDecode(data);
    if (json['result'] == "error") {
      return Container();
    } else {
      for (var rasp in json['data']) {
        Raspbbery raspbbery = Raspbbery.fromJson(rasp);
        raspbbery2.add(raspbbery);
      }
      return ListView.builder(
          itemCount: raspbbery2.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      if (jabatan_id == "1" || jabatan_id == "2") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailRaspi(raspberry_id: raspbbery2[index].id),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SensorList(raspberry_id: raspbbery2[index].id),
                          ),
                        );
                      }
                    },
                    child: Card(
                      child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Column(
                            children: [
                              Container(
                                  width: 300,
                                  height: 200,
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: raspbbery2[index].tipe ==
                                            "Raspberry Pi 3"
                                        ? AssetImage(
                                            "assets/images/raspberry-pi-3.jpg")
                                        : raspbbery2[index].tipe ==
                                                "Raspberry Pi 3b"
                                            ? AssetImage(
                                                "assets/images/raspberry-pi-3b.jpg")
                                            : raspbbery2[index].tipe ==
                                                    "Raspberry Pi 3b+"
                                                ? AssetImage(
                                                    "assets/images/raspberry-pi-3b+.jpg")
                                                : AssetImage(
                                                    "assets/images/raspberry-pi-4.jpg"),
                                    fit: BoxFit.fill,
                                    // alignment: Alignment.topCenter,
                                  ))),
                              Divider(
                                thickness: 1,
                                color: Color.fromARGB(255, 105, 105, 105),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "id: " + raspbbery2[index].id,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(raspbbery2[index].tipe,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Row(children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Color.fromARGB(255, 95, 95, 95),
                                ),
                                Text(raspbbery2[index].lokasi,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 95, 95, 95)))
                              ])
                            ],
                          )),
                    ))
              ],
            );
          });
    }
  }

  buildContainer(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height,
                  width: 800,
                  child: FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (MediaQuery.of(context).size.width <= 800) {
                            return raspbberyMobileList(
                                snapshot.data.toString());
                          } else {
                            return GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 4.0,
                                childAspectRatio: 1.25 / 1,
                                children: raspberryList(
                                    context, snapshot.data.toString()));
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    if (jabatan_id == "1" || jabatan_id == "2") {
      return Scaffold(
          body: buildContainer(context),
          floatingActionButton: Tooltip(
            message: "Halaman Tambah Raspberr",
            child: FloatingActionButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "/addraspi");
              },
              child: const Icon(Icons.add),
            ),
          ));
    } else {
      return Scaffold(body: buildContainer(context));
    }
  }
}
