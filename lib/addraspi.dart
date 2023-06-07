import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRaspi extends StatefulWidget {
  AddRaspi({Key? key}) : super(key: key);
  @override
  AddRaspiState createState() {
    return AddRaspiState();
  }
}

const List<String> raspilist = <String>[
  'Raspberry Pi 3',
  'Raspberry Pi 3b',
  'Raspberry Pi 3b+',
  'Raspberry Pi 4',
];

class AddRaspiState extends State<AddRaspi> {
  String raspi = raspilist.first, id = "";
  String raspipict = "assets/images/raspberry-pi-3.jpg", note = "";
  String error_create = "";
  int rand = 0;

  void submit(BuildContext context) async {
    final response = await http.post(
        Uri.parse("http://192.168.137.1/tugas_akhir/addraspi.php"),
        body: {'raspberry_id': id, 'type': raspi, 'note': note});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data telah berhasil ditambahkan')));
        Navigator.popAndPushNamed(context, "home");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Raspberry"),
        ),
        body: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Container(
                    width: 500,
                    alignment: Alignment.center,
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              "Pilih Jenis Raspberry dan \nIsikan Lokasi Penempatannya",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                            width: 300,
                            height: 200,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: NetworkImage(raspipict),
                              fit: BoxFit.fill,
                              // alignment: Alignment.topCenter,
                            ))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Tipe Raspberry",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: DropdownButton<String>(
                          value: raspi,
                          items: raspilist
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              if (value == "Raspberry Pi 3") {
                                raspipict = "assets/images/raspberry-pi-3.jpg";
                              } else if (value == "Raspberry Pi 3b") {
                                raspipict = "assets/images/raspberry-pi-3b.jpg";
                              } else if (value == "Raspberry Pi 3b+") {
                                raspipict =
                                    "assets/images/raspberry-pi-3b+.jpg";
                              } else if (value == "Raspberry Pi 4") {
                                raspipict = "assets/images/raspberry-pi-4.jpg";
                              }
                              raspi = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Lokasi",
                            style: TextStyle(fontSize: 16),
                          )),
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
                              hintText:
                                  'Berikan keterangan lokasi Raspberry ini'),
                        ),
                      ),
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
                                if (note == "") {
                                  setState(() {
                                    error_create = "Lokasi harus diisi";
                                  });
                                } else {
                                  setState(() {
                                    rand = 1000 + Random().nextInt(9999 - 1000);
                                    id = raspi
                                            .substring(10)
                                            .toLowerCase()
                                            .replaceAll(' ', '-') +
                                        "-" +
                                        rand.toString();
                                    submit(context);
                                  });
                                }
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
