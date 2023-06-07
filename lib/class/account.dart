class User {
  final String username, email, nama_depan, nama_belakang, avatar, jabatan;
  final int status, id_jabatan;

  User({
    required this.username,
    required this.email,
    required this.nama_depan,
    required this.nama_belakang,
    required this.avatar,
    required this.jabatan,
    required this.status,
    required this.id_jabatan,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'] as String,
        email: json['email'] as String,
        nama_depan: json['nama_depan'] as String,
        nama_belakang: json['nama_belakang'] as String,
        avatar: json['avatar'] as String,
        status: json['status'] as int,
        id_jabatan: json['jabatan_id'] as int,
        jabatan: json['jabatan'] as String);
  }
}
