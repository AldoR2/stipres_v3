class FullLecturerModel {
  FullLecturerModel({
    required this.nama,
    required this.nip,
    required this.email,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatLahir,
    required this.tglLahir,
    required this.alamat,
    required this.noTelp,
    required this.namaProdi,
  });

  final String nama;
  final String nip;
  final String email;
  final String jenisKelamin;
  final String agama;
  final String? tempatLahir;
  final String tglLahir;
  final String alamat;
  final String noTelp;
  final String namaProdi;

  factory FullLecturerModel.fromJson(Map<String, dynamic> json) {
    return FullLecturerModel(
      nama: json["nama"],
      nip: json["nip"],
      email: json["email"],
      jenisKelamin: json["jenis_kelamin"],
      agama: json["agama"],
      tempatLahir: json["tempat_lahir"],
      tglLahir: json['tgl_lahir'],
      alamat: json["alamat"],
      noTelp: json["no_telp"],
      namaProdi: json["nama_prodi"],
    );
  }
}
