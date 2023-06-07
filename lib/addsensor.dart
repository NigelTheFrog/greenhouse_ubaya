import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/detailraspi.dart';
import 'package:greenhouse_ubaya/home.dart';
import 'package:http/http.dart' as http;

class AddSensor extends StatefulWidget {
  String raspberry_id = "";
  AddSensor({Key? key, required this.raspberry_id}) : super(key: key);
  @override
  AddSensorState createState() {
    return AddSensorState();
  }
}

const List<String> sensorList = <String>[
  'Sensor Kelembaban Tanah',
  'Sensor Suhu',
  'Sensor pH',
  'Sensor Air',
  'Sensor Cahaya'
];

const List<String> sensorPortList = <String>[
  'A0',
  'A2',
  'A4',
  'A6',
  'D5',
  'D16',
  'D18',
  'D22',
  'D24',
  'D26',
];

const List<String> actuatorList = <String>[
  'Relay',
  'Motor Servo',
];

const List<String> actuatorPortList = <String>[
  'D5',
  'D16',
  'D18',
  'D22',
  'D24',
  'D26',
  'P12',
  'P13',
];

class AddSensorState extends State<AddSensor> {
  String sensor_port = sensorPortList.first,
      sensor_name = sensorList.first,
      actuator_name = actuatorList.first,
      actuator_port = actuatorPortList.first,
      note = "",
      satuan = "wfv",
      id = "";
  String sensorpict = "assets/images/soil-moisture-sensor.jpg",
      actuatorpict = "assets/images/relay.png";
  String error_create = "";

  int diameterSelang = 0, tinggiSelang = 0, volumeTanah = 0;
  double nilaiToleransi = 0;

  void submit(BuildContext context) async {
    final response = await http.post(
        Uri.parse("http://192.168.137.1/tugas_akhir/sensor/addsensor.php"),
        body: {
          'raspberry_id': widget.raspberry_id,
          'id': "${sensor_port}-$id-${actuator_port}",
          'nama_sensor': sensor_name,
          'port_sensor': sensor_port,
          'nama_aktuator': actuator_name,
          'port_aktuator': actuator_port,
          'toleransi': nilaiToleransi.toString(),
          'satuan': satuan
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data has been added succesfully')));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailRaspi(raspberry_id: widget.raspberry_id),
          ),
        );
      } else {
        setState(() {
          error_create = json['messgae'];
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

  Widget buildToleransiSelang() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: 325,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  diameterSelang = int.parse(value);
                },
                decoration: const InputDecoration(
                    labelStyle: TextStyle(fontSize: 13),
                    label: Text("Diameter Selang"),
                    hintText: 'Dalam cm'),
              )),
          SizedBox(
            width: 100,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                tinggiSelang = int.parse(value);
              },
              decoration: const InputDecoration(
                  labelStyle: TextStyle(fontSize: 14),
                  label: Text("Panjang Selang"),
                  hintText: 'Dalam cm'),
            ),
          ),
          SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  volumeTanah = int.parse(value);
                },
                decoration: const InputDecoration(
                    labelStyle: TextStyle(fontSize: 14),
                    label: Text("Volume Tanah"),
                    hintText: 'Dalam liter'),
              )),
        ],
      ),
    );
  }

  Widget buildChooseActuator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: 300,
              height: 200,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(actuatorpict),
                fit: BoxFit.fill,
                // alignment: Alignment.topCenter,
              ))),
        ),
        SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Nama Aktuator"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DropdownButton<String>(
                        value: actuator_name,
                        items: actuatorList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            actuator_name = value!;
                            if (value == "Relay") {
                              actuatorpict = "assets/images/relay.png";
                            } else {
                              actuatorpict = "assets/images/servo.jpg";
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Port Aktuator"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DropdownButton<String>(
                        value: actuator_port,
                        items: actuatorPortList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            actuator_port = value!;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ],
    );
  }

  Widget buildChooseSensor() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            width: 300,
            height: 200,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(sensorpict),
              fit: BoxFit.fill,
              // alignment: Alignment.topCenter,
            ))),
      ),
      SizedBox(
          width: 325,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Nama Sensor"),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: DropdownButton<String>(
                      value: sensor_name,
                      items: sensorList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          sensor_name = value!;
                          if (value == "Sensor Kelembaban Tanah") {
                            satuan = "wfv";
                            sensorpict =
                                "assets/images/soil-moisture-sensor.jpg";
                          } else if (value == "Sensor Suhu") {
                            satuan = "celsius";
                            sensorpict = "assets/images/dht-11.jpg";
                          } else if (value == "Sensor pH") {
                            satuan = "pH";
                            sensorpict = "assets/images/ph.jpg";
                          } else if (value == "Sensor Cahaya") {
                            satuan = "lux";
                            sensorpict = "assets/images/light-sensor.jpg";
                          } else {
                            satuan = "";
                            sensorpict = "assets/images/water-sensor.png";
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("Port Sensor"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButton<String>(
                      value: sensor_port,
                      items: sensorPortList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          sensor_port = value!;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Sensor"),
        ),
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Pilih Jenis Sensor dan Portnya \nBeserta Aktuator dan Portnya",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              if (MediaQuery.of(context).size.width > 650)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildChooseSensor(),
                    buildChooseActuator(),
                  ],
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildChooseSensor(),
                    buildChooseActuator(),
                  ],
                ),
              if (sensor_name == "Sensor Kelembaban Tanah" ||
                  sensor_name == "Sensor pH")
                buildToleransiSelang()
              else
                Container(),
              Container(
                width: 300,
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      note = value;
                    });
                  },
                  decoration: const InputDecoration(
                      label: Text("Lokasi Sensor"),
                      hintText: 'Berikan keterangan lokasi sensor'),
                ),
              ),
              if (error_create != "")
                Text(error_create, style: const TextStyle(color: Colors.red)),
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
                        if (sensor_name == "Sensor Kelembaban Tanah" ||
                            sensor_name == "Sensor pH") {
                          nilaiToleransi = ((pi *
                                      pow((diameterSelang / 2), 2) *
                                      tinggiSelang) /
                                  volumeTanah) *
                              100;
                        } else if (sensor_name == "Sensor Suhu") {
                          nilaiToleransi = 0.5;
                        }
                        id = sensor_name.toLowerCase().replaceAll(' ', '-');
                        submit(context);
                      },
                      child: const Text(
                        'Tambah Sensor',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )),
            ]))));
  }
}
