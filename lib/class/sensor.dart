class Sensor {
  final String id,
      nama_sensor,
      port_sensor,
      nama_aktuator,
      port_aktuator,
      satuan,
      toleransi;

  Sensor({
    required this.id,
    required this.nama_sensor,
    required this.port_sensor,
    required this.nama_aktuator,
    required this.port_aktuator,
    required this.satuan,
    required this.toleransi,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] as String,
      nama_sensor: json['nama_sensor'] as String,
      port_sensor: json['port_sensor'] as String,
      nama_aktuator: json['nama_aktuator'] as String,
      port_aktuator: json['port_aktuator'] as String,
      satuan: json['satuan'] as String,
      toleransi: json['toleransi'] as String,
    );
  }
}
