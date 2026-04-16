class DataMahasiswa {
  final String nim;
  final String nama;
  final String email;
  final String jenisKelamin;

  DataMahasiswa({
    required this.nim,
    required this.nama,
    required this.email,
    required this.jenisKelamin,
  });

  factory DataMahasiswa.fromJson(Map<String, dynamic> json) {
    return DataMahasiswa(
      nim: json["nim"],
      nama: json["nama"],
      email: json["email"],
      jenisKelamin: json["jenis_kelamin"],
    );
  }
}
