import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/class/log.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LogChart extends StatefulWidget {
  String sensor_id,
      nama_sensor,
      port_sensor,
      nama_aktuator,
      port_aktuator,
      satuan,
      toleransi;
  LogChart(
      {super.key,
      required this.sensor_id,
      required this.nama_sensor,
      required this.port_sensor,
      required this.nama_aktuator,
      required this.port_aktuator,
      required this.satuan,
      required this.toleransi});
  @override
  State<StatefulWidget> createState() {
    return _LogChartState();
  }
}

class _LogChartState extends State<LogChart> {
  TextEditingController startdatecontroller = TextEditingController(),
      enddatecontroller = TextEditingController();
  late Timer timer;
  String startdate = "", enddate = "";
  late TooltipBehavior _tooltip;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://192.168.173.1/tugas_akhir/log/logchart.php"),
        body: {
          'startdate': startdate,
          'enddate': enddate,
          'sensor_id': widget.sensor_id
        });
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
    var date = DateTime.now();
    startdatecontroller.text = DateFormat.yMMMMEEEEd('id').format(date);
    enddatecontroller.text = DateFormat.yMMMMEEEEd('id')
        .format(DateTime(date.year, date.month, date.day + 7));
    startdate = date.toString().substring(0, 10);
    enddate = DateTime(date.year, date.month, date.day + 7)
        .toString()
        .substring(0, 10);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
    });
  }

  Widget logChart(data) {
    List<Log> log2 = [];
    Map json = jsonDecode(data);
    if (json['result'] == "error") {
      return Container();
    } else {
      for (var mov in json['data']) {
        Log log = Log.fromJson(mov);
        log2.add(log);
      }
      return SingleChildScrollView(
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            ColumnSeries<Log, String>(
                dataSource: log2,
                xValueMapper: (Log data, _) => data.tanggal,
                yValueMapper: (Log data, _) => data.average,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                // Map color for each data points from the data source
                pointColorMapper: (Log data, _) {
                  if (widget.nama_sensor == "Sensor Cahaya") {
                    if (data.average! > 750 || data.average! < 300) {
                      return Colors.red;
                    } else if (data.average! >= 300 && data.average! <= 400 ||
                        data.average! >= 600 && data.average! <= 750) {
                      return Colors.yellow;
                    } else {
                      return Colors.lightGreen;
                    }
                  } else if (widget.nama_sensor == "Sensor Suhu") {
                    if (data.average! > 27 || data.average! < 18) {
                      return Colors.red;
                    } else if (data.average! >= 18 && data.average! <= 20 ||
                        data.average! >= 25 && data.average! <= 27) {
                      return Colors.yellow;
                    } else {
                      return Colors.lightGreen;
                    }
                  }
                })
          ],
        ),
      );
    }
  }

  Widget buildStartDate() {
    return SizedBox(
      height: 50,
      width: 300,
      child: Row(children: [
        Expanded(
            child: TextFormField(
          decoration: InputDecoration(
            labelText: "Tanggal mulai",
          ),
          controller: startdatecontroller,
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
                  startdate = value.toString().substring(0, 10);
                  String formattedDate =
                      DateFormat.yMMMMEEEEd('id').format(value!);
                  startdatecontroller.text = formattedDate;
                });
              });
            },
            child: Icon(
              Icons.calendar_today_sharp,
              color: Colors.white,
              size: 24.0,
            ))
      ]),
    );
  }

  Widget buildEndDate() {
    return SizedBox(
      height: 50,
      width: 300,
      child: Row(children: [
        Expanded(
            child: TextFormField(
          decoration: InputDecoration(
            labelText: "Tanggal berakhir",
          ),
          controller: enddatecontroller,
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
                  enddate = value.toString().substring(0, 10);
                  String formattedDate =
                      DateFormat.yMMMMEEEEd('id').format(value!);
                  enddatecontroller.text = formattedDate;
                });
              });
            },
            child: Icon(
              Icons.calendar_today_sharp,
              color: Colors.white,
              size: 24.0,
            ))
      ]),
    );
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
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Sensor ID: ${widget.sensor_id}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                "\nPILIH TANGGAL UNTUK MELAKUKAN FILTRASI DATA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Satuan: ${widget.satuan}, Toleransi: ${widget.toleransi}",
                style: TextStyle(
                    color: Color.fromARGB(255, 92, 92, 92), fontSize: 13),
              )),
          Container(
              alignment: Alignment.topCenter,
              width: 700,
              child: MediaQuery.of(context).size.width >= 650
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [buildStartDate(), buildEndDate()],
                    )
                  : Column(
                      children: [buildStartDate(), buildEndDate()],
                    )),
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
          SizedBox(
              height: 500,
              width: 500,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return logChart(snapshot.data.toString());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })),
        ],
      )),
    ));
  }
}
