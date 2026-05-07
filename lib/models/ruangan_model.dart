class RuanganModel {
  final String id;
  final String namaRuangan;

  RuanganModel({
    required this.id,
    required this.namaRuangan,
  });

  factory RuanganModel.fromJson(Map<String, dynamic> json) {
    return RuanganModel(
      id: json["id"].toString(),
      namaRuangan: json["nama_ruangan"],
    );
  }
}
