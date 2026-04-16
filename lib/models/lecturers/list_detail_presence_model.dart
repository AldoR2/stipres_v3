class ListDetailPresensi {
  final String? nim;
  final String? nama;
  final int? status;
  String? keterangan;
  String? jenisKelamin;

  ListDetailPresensi({
    required this.nim,
    required this.nama,
    required this.status,
    this.keterangan,
    required this.jenisKelamin,
  });

  factory ListDetailPresensi.fromJson(Map<String, dynamic> json) {
    return ListDetailPresensi(
      nim: json["nim"],
      nama: json["nama"],
      status: json["status"],
      jenisKelamin: json["jenis_kelamin"],
    );
  }
}
