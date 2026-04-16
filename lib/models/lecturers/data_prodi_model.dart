class DataProdi {
  final String id;
  final String namaProdi;

  DataProdi({
    required this.id,
    required this.namaProdi,
  });

  factory DataProdi.fromJson(Map<String, dynamic> json) {
    return DataProdi(
      id: json["id"].toString(),
      namaProdi: json["nama_prodi"],
    );
  }
}
