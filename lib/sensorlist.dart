import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/addsensor.dart';
import 'package:greenhouse_ubaya/class/sensor.dart';
import 'package:greenhouse_ubaya/detailsensor.dart';
import 'package:greenhouse_ubaya/logchart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String sensor_id = "", jabatan_id = "";

class SensorList extends StatefulWidget {
  String raspberry_id;
  SensorList({super.key, required this.raspberry_id});
  @override
  State<StatefulWidget> createState() {
    return _SensorListState();
  }
}

class _SensorListState extends State<SensorList> {
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419017/images/sensor/sensorlist.php"),
        body: {'raspberry_id': widget.raspberry_id});
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

  Widget daftarsensor(data) {
    List<Sensor> sensor2 = [];
    Map json = jsonDecode(data);
    if (json['result'] == "error") {
      return Center(
        child: Text(
          "Tidak ada data sensor pada raspbery ${widget.raspberry_id} ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      for (var mov in json['data']) {
        Sensor sensor = Sensor.fromJson(mov);
        sensor2.add(sensor);
      }
      return ListView.builder(
        itemCount: sensor2.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            if (sensor2[index].nama_sensor != "Sensor Air") {
                              if (jabatan_id != "4") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailSensor(
                                        sensor_id: sensor2[index].id,
                                        nama_sensor: sensor2[index].nama_sensor,
                                        port_sensor: sensor2[index].port_sensor,
                                        nama_aktuator:
                                            sensor2[index].nama_aktuator,
                                        port_aktuator:
                                            sensor2[index].port_aktuator,
                                        satuan: sensor2[index].satuan,
                                        toleransi: sensor2[index].nama_sensor ==
                                                "Sensor Suhu"
                                            ? "${sensor2[index].toleransi}°C"
                                            : sensor2[index].nama_sensor ==
                                                    "Sensor Cahaya"
                                                ? "-"
                                                : "${sensor2[index].toleransi}%"),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogChart(
                                        sensor_id: sensor2[index].id,
                                        nama_sensor: sensor2[index].nama_sensor,
                                        port_sensor: sensor2[index].port_sensor,
                                        nama_aktuator:
                                            sensor2[index].nama_aktuator,
                                        port_aktuator:
                                            sensor2[index].port_aktuator,
                                        satuan: sensor2[index].satuan,
                                        toleransi: sensor2[index].nama_sensor ==
                                                "Sensor Suhu"
                                            ? "${sensor2[index].toleransi}°C"
                                            : sensor2[index].nama_sensor ==
                                                    "Sensor Cahaya"
                                                ? "-"
                                                : "${sensor2[index].toleransi}%"),
                                  ),
                                );
                              }
                            }
                          },
                          child: Card(
                              child: Container(
                                  width: 800,
                                  child: ListTile(
                                    leading: ClipRRect(
                                      child: sensor2[index].nama_sensor ==
                                              "Sensor Kelembaban Tanah"
                                          ? Image.asset(
                                              "assets/images/soil-moisture-sensor.jpg",
                                              scale: 2,
                                            )
                                          : sensor2[index].nama_sensor ==
                                                  "Sensor Cahaya"
                                              ? Image.asset(
                                                  "assets/images/light-sensor.jpg")
                                              : sensor2[index].nama_sensor ==
                                                      "Sensor Suhu"
                                                  ? Image.asset(
                                                      "assets/images/dht-11.jpg")
                                                  : sensor2[index]
                                                              .nama_sensor ==
                                                          "Sensor pH"
                                                      ? Image.asset(
                                                          "assets/images/ph.jpg")
                                                      : Image.asset(
                                                          "assets/images/water-sensor.png"),
                                    ),
                                    title: Text(sensor2[index].nama_sensor),
                                    subtitle: Text(
                                        "Port Sensor: ${sensor2[index].port_sensor}"),
                                    trailing: Column(children: [
                                      Text(
                                          "Tipe Actuator: ${sensor2[index].nama_aktuator}"),
                                      Text(
                                          "Port Actuator: ${sensor2[index].port_aktuator}")
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
    if (jabatan_id == "1" || jabatan_id == "2") {
      return Scaffold(
          floatingActionButton: Tooltip(
            message: "Tambah Sensor",
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddSensor(raspberry_id: widget.raspberry_id)));
              },
            ),
          ),
          body: ListView(children: <Widget>[
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
          ]));
    } else {
      return Scaffold(
          appBar: AppBar(title: Text("Daftar Sensor")),
          body: ListView(children: <Widget>[
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
          ]));
    }
  }
}
