class Raspbbery {
  final String id, tipe, lokasi;

  Raspbbery({
    required this.id,
    required this.tipe,
    required this.lokasi,
  });

  factory Raspbbery.fromJson(Map<String, dynamic> json) {
    return Raspbbery(
      id: json['id'] as String,
      tipe: json['tipe'] as String,
      lokasi: json['lokasi'] as String,
    );
  }
}
