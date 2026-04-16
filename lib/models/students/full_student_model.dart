class FullStudentModelApi {
  String nama;
  String nim;
  String email;
  String jenisKelamin;
  String agama;
  String tempatLahir;
  String tglLahir;
  String alamat;
  int semester;
  String noTelp;
  String namaProdi;

  FullStudentModelApi(
      {required this.nama,
      required this.nim,
      required this.email,
      required this.jenisKelamin,
      required this.agama,
      required this.tempatLahir,
      required this.tglLahir,
      required this.alamat,
      required this.semester,
      required this.noTelp,
      required this.namaProdi});

  factory FullStudentModelApi.fromJson(Map<String, dynamic> json) {
    return FullStudentModelApi(
      nama: json['nama'],
      nim: json['nim'],
      email: json['email'],
      jenisKelamin: json['jenis_kelamin'],
      agama: json['agama'],
      tempatLahir: json['tempat_lahir'],
      tglLahir: json['tgl_lahir'],
      alamat: json['alamat'],
      semester: json['semester'],
      noTelp: json['no_telp'],
      namaProdi: json['nama_prodi'],
    );
  }
}
