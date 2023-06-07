class Log {
  final String tanggal;
  final double? value, average;
  final String? timestamp, status;

  Log({
    this.value,
    this.status,
    this.timestamp,
    this.average,
    required this.tanggal,
    
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
        value: json['value'] as double?,
        timestamp: json['timestamp'] as String?,
        tanggal: json['tanggal'] as String,
        status: json['status'] as String?,
        average: json['average'] as double?);
   
  }
}
