class Troubleshoot {
  final String id, nama_sensor, port_sensor, error_id, error_type;
  final String? solusi, lokasi;

  Troubleshoot(
      {required this.id,
      required this.nama_sensor,
      required this.port_sensor,
      required this.error_id,
      required this.error_type,
      this.solusi,
      this.lokasi});

  factory Troubleshoot.fromJson(Map<String, dynamic> json) {
    return Troubleshoot(
      id: json['id'] as String,
      nama_sensor: json['nama_sensor'] as String,
      port_sensor: json['port_sensor'] as String,
      error_id: json['error_id'] as String,
      error_type: json['error_type'] as String,
      solusi: json['solusi'] as String?,
      lokasi: json['lokasi'] as String?,
    );
  }
}
