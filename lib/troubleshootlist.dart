import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/troubleshoot.dart';
import 'package:greenhouse_ubaya/detailtroubleshoot.dart';
import 'package:http/http.dart' as http;

class TroubleShootList extends StatefulWidget {
  String raspberry_id;
  TroubleShootList({super.key, required this.raspberry_id});
  @override
  State<StatefulWidget> createState() {
    return _TroubleShootListState();
  }
}

class _TroubleShootListState extends State<TroubleShootList> {
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419017/images/errorlist.php"),
        body: {'raspberry_id': widget.raspberry_id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget daftarTrouble(data) {
    List<Troubleshoot> error2 = [];
    Map json = jsonDecode(data);
    if (json['result'] == "error") {
      return Center(
        child: Text(
          "Tidak terdapat masalah pada raspbery ${widget.raspberry_id} ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      for (var mov in json['data']) {
        Troubleshoot error = Troubleshoot.fromJson(mov);
        error2.add(error);
      }
      return ListView.builder(
        itemCount: error2.length,
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
                                builder: (context) => DetailTroubleShoot(
                                  id: error2[index].id,
                                  nama_sensor: error2[index].nama_sensor,
                                ),
                              ),
                            );
                          },
                          child: Card(
                              child: Container(
                                  width: 800,
                                  child: ListTile(
                                    leading: ClipRRect(
                                      child: error2[index].nama_sensor ==
                                              "Sensor Kelembaban Tanah"
                                          ? Image.asset(
                                              "assets/images/soil-moisture-sensor.jpg",
                                              scale: 2,
                                            )
                                          : error2[index].nama_sensor ==
                                                  "Sensor Cahaya"
                                              ? Image.asset(
                                                  "assets/images/light-sensor.jpg")
                                              : error2[index].nama_sensor ==
                                                      "Sensor Suhu"
                                                  ? Image.asset(
                                                      "assets/images/dht-11.jpg")
                                                  : Image.asset(
                                                      "assets/images/dht-11.jpg"),
                                    ),
                                    title: Text(error2[index].nama_sensor),
                                    subtitle: Text(
                                        "Port Sensor: ${error2[index].port_sensor} \nMasalah: ${error2[index].error_type}"),
                                    trailing: Column(children: [
                                      Text("Error Code:"),
                                      Text(
                                        error2[index].error_id,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ]),
                                  ))))
                    ],
                  )));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: 600,
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return daftarTrouble(snapshot.data.toString());
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }))
    ]));
  }
}
