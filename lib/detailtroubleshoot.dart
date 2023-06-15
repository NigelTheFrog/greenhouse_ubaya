import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/troubleshoot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class DetailTroubleShoot extends StatefulWidget {
  String id, nama_sensor;
  DetailTroubleShoot({super.key, required this.id, required this.nama_sensor});
  @override
  _DetailTroubleShootState createState() {
    return _DetailTroubleShootState();
  }
}

class _DetailTroubleShootState extends State<DetailTroubleShoot> {
  TextEditingController id = TextEditingController();
  TextEditingController portSensor = TextEditingController();
  TextEditingController lokasiSensor = TextEditingController();
  TextEditingController keteranganError = TextEditingController();
  TextEditingController solusi = TextEditingController();

  String error_code = "";
  Troubleshoot? _troubleshoot;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419017/images/detailerror.php"),
        body: {'id': widget.id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _troubleshoot = Troubleshoot.fromJson(json['data']);
      setState(() {
        id.text = widget.id;
        portSensor.text = _troubleshoot!.port_sensor;
        lokasiSensor.text = _troubleshoot!.lokasi.toString();
        keteranganError.text = _troubleshoot!.error_type;
        solusi.text = _troubleshoot!.solusi.toString();
        error_code = _troubleshoot!.error_id;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
  }

  Widget showPicture() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10),
            height: 200,
            width: 150,
            child: widget.nama_sensor == "Sensor Kelembaban Tanah"
                ? Image.asset("assets/images/soil-moisture-sensor.jpg")
                : widget.nama_sensor == "Sensor Cahaya"
                    ? Image.asset("assets/images/light-sensor.jpg")
                    : widget.nama_sensor == "Sensor Suhu"
                        ? Image.asset("assets/images/dht-11.jpg")
                        : Image.asset("assets/images/dht-11.jpg")),
        // : Image.file(_avatar_proses!),

        Text(
          "Error Code: \n$error_code",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(10),
            width: 440,
            child: TextField(
              controller: id,
              decoration: const InputDecoration(
                labelText: 'ID Sensor',
              ),
              enabled: false,
            )),
        Container(
            padding: EdgeInsets.all(10),
            width: 440,
            child: TextField(
              controller: portSensor,
              decoration: const InputDecoration(
                labelText: 'Port Sensor',
              ),
              enabled: false,
            )),
        Container(
            padding: EdgeInsets.all(10),
            width: 440,
            child: TextField(
              controller: lokasiSensor,
              decoration: const InputDecoration(
                labelText: 'Lokasi Sensor',
              ),
              enabled: false,
            )),
        Container(
            padding: EdgeInsets.all(10),
            width: 440,
            child: TextField(
              controller: keteranganError,
              decoration: const InputDecoration(
                labelText: 'Keterangan Masalah',
              ),
              enabled: false,
            )),
        Container(
            padding: EdgeInsets.all(10),
            width: 440,
            child: TextField(
              controller: solusi,
              minLines: 1,
              maxLines: 50,
              decoration: const InputDecoration(
                labelText: 'Solusi',
              ),
              enabled: false,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Troubleshoot"),
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(widget.nama_sensor,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  MediaQuery.of(context).size.width >= 650
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[showPicture(), buildData()],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[showPicture(), buildData()])
                ],
              ))),
    );
  }
}
