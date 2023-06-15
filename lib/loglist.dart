import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/log.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LogList extends StatefulWidget {
  String sensor_id,
      nama_sensor,
      port_sensor,
      nama_aktuator,
      port_aktuator,
      toleransi,
      satuan;
  LogList({
    super.key,
    required this.sensor_id,
    required this.nama_sensor,
    required this.port_sensor,
    required this.nama_aktuator,
    required this.port_aktuator,
    required this.toleransi,
    required this.satuan,
  });
  @override
  State<StatefulWidget> createState() {
    return _LogListState();
  }
}

class _LogListState extends State<LogList> {
  TextEditingController _datecontroller = TextEditingController();
  late Timer timer;
  String date = "";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419017/images/log/loglist.php"),
        body: {'tanggal': date, 'sensor_id': widget.sensor_id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();

    _datecontroller.text = DateFormat.yMMMMEEEEd('id').format(DateTime.now());
    date = DateTime.now().toString().substring(0, 10);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  Widget loglist(data) {
    List<Log> log2 = [];
    Map json = jsonDecode(data);
    if (json['result'] == "error") {
      return Container();
    } else {
      for (var mov in json['data']) {
        Log log = Log.fromJson(mov);
        log2.add(log);
      }
      return ListView.builder(
          scrollDirection: MediaQuery.of(context).size.width >= 600
              ? Axis.vertical
              : Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext ctxt, int index) {
            return DataTable(
                headingRowHeight: 0,
                columns: [
                  DataColumn(label: Container()),
                  DataColumn(label: Container()),
                  DataColumn(label: Container())
                ],
                rows: log2
                    .map<DataRow>((element) => DataRow(
                            color: MaterialStateColor.resolveWith((states) {
                              if (widget.nama_sensor ==
                                  "Sensor Kelembaban Tanah") {
                                return element.status ==
                                        "Menunggu tanah menyerap cairan"
                                    ? Colors.white
                                    : element.value! > 750 ||
                                            element.value! < 250
                                        ? Color.fromARGB(255, 255, 96, 85)
                                        : element.value! >= 250 &&
                                                    element.value! <= 400 ||
                                                element.value! >= 600 &&
                                                    element.value! <= 750
                                            ? Color.fromARGB(255, 250, 233, 75)
                                            : Color.fromARGB(255, 72, 225,
                                                85); //make tha magic!
                              } else if ((widget.nama_sensor ==
                                  "Sensor Suhu")) {
                                return element.value! < 18 ||
                                        element.value! > 27
                                    ? Color.fromARGB(255, 255, 96, 85)
                                    : element.value! >= 18 &&
                                                element.value! <= 20 ||
                                            element.value! >= 25 &&
                                                element.value! <= 27
                                        ? Color.fromARGB(255, 250, 233, 75)
                                        : Color.fromARGB(255, 72, 225, 85);
                              } else if ((widget.nama_sensor ==
                                  "Sensor Cahaya")) {
                                return element.value! > 900 ||
                                        element.value! < 100
                                    ? Color.fromARGB(255, 255, 96, 85)
                                    : data.average! <= 900 &&
                                                data.average! >= 400 ||
                                            data.average! >= 100 &&
                                                data.average! <= 200
                                        ? Color.fromARGB(255, 250, 233, 75)
                                        : Color.fromARGB(255, 72, 225, 85);
                              } else {
                                return element.status ==
                                        "Menunggu tanah menyerap cairan"
                                    ? Colors.white
                                    : element.value! < 5.5 || element.value! > 8
                                        ? Color.fromARGB(255, 255, 96, 85)
                                        : element.value! >= 5.5 &&
                                                    element.value! <= 6.5 ||
                                                element.value! >= 7 &&
                                                    element.value! <= 8
                                            ? Color.fromARGB(255, 250, 233, 75)
                                            : Color.fromARGB(255, 72, 225, 85);
                              }
                            }),
                            cells: [
                              DataCell(Text(
                                element.value.toString(),
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Text(element.status.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(Text(element.timestamp.toString(),
                                  textAlign: TextAlign.center)),
                            ]))
                    .toList());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 20),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.topCenter,
              child: Text(
                "Sensor ID: ${widget.sensor_id}",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Nama Sensor: ${widget.nama_sensor}, Port: ${widget.port_sensor}",
                style: TextStyle(
                    color: Color.fromARGB(255, 92, 92, 92), fontSize: 13),
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Aktuator: ${widget.nama_aktuator}, Port: ${widget.port_aktuator}",
                style: TextStyle(
                    color: Color.fromARGB(255, 92, 92, 92), fontSize: 13),
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Satuan: ${widget.satuan}, Toleransi: ${widget.toleransi}",
                style: TextStyle(
                    color: Color.fromARGB(255, 92, 92, 92), fontSize: 13),
              )),
          Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.topCenter,
              child: Text(
                "PILIH TANGGAL UNTUK MELAKUKAN FILTRASI DATA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
          SizedBox(
            height: 50,
            width: 300,
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Tanggal ",
                ),
                controller: _datecontroller,
              )),
              ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2200))
                        .then((value) {
                      setState(() {
                        date = value.toString().substring(0, 10);
                        String formattedDate =
                            DateFormat.yMMMMEEEEd('id').format(value!);
                        _datecontroller.text = formattedDate;
                      });
                    });
                  },
                  child: Icon(
                    Icons.calendar_today_sharp,
                    color: Colors.white,
                    size: 24.0,
                  ))
            ]),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                widget.nama_sensor == "Sensor Kelembaban Tanah"
                    ? "\nSTANDAR PENGUKURAN \nSENSOR KELEMBABAN TANAH"
                    : widget.nama_sensor == "Sensor Cahaya"
                        ? ""
                        : widget.nama_sensor == "Sensor Suhu"
                            ? "\nSTANDAR PENGUKURAN \nSENSOR SUHU RUANGAN"
                            : "\nSTANDAR PENGUKURAN \nSENSOR KEASAMAN TANAH",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              )),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            height: 90,
            alignment: Alignment.center,
            width: 600,
            child: widget.nama_sensor == "Sensor Kelembaban Tanah"
                ? Image.asset("assets/images/legend-soil-moisture.png")
                : widget.nama_sensor == "Sensor Cahaya"
                    ? Image.asset("")
                    : widget.nama_sensor == "Sensor Suhu"
                        ? Image.asset("assets/images/legend-temperature.png")
                        : Image.asset("assets/images/legend-ph.png"),
          ),
          Container(
            width: 450,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Value",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Timestamp", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
              height: 600,
              width: 500,
              alignment: Alignment.topCenter,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return loglist(snapshot.data.toString());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })),
        ],
      )),
    ));
  }
}
