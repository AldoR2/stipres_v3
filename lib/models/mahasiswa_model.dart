class Mahasiswa {
  final String nim;
  final String nama;
  final String email;
  final int idProdi;
  final int semester;
  final String? status;
  final String? message;

  Mahasiswa(
      {this.status,
      this.message,
      required this.nim,
      required this.nama,
      required this.email,
      required this.idProdi,
      required this.semester});

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      nim: json['nim'],
      nama: json['nama'],
      email: json['email'],
      idProdi: json['prodi_id'],
      semester: json['semester'],
      status: json['status'], // Ambil dari root JSON
      message: json['message'], // Ambil dari root JSON
    );
  }

  Map<String, dynamic> toJson() => {
        'nim': nim,
        'nama': nama,
        'email': email,
        'id_prodi': idProdi,
        'semester': semester,
      };
}
