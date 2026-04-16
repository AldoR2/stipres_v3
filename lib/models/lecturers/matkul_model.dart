class MatkulModel {
  final int? idMatkul;
  final String? kodeMatkul;
  final String? namaMatkul;

  MatkulModel({
    required this.idMatkul,
    required this.kodeMatkul,
    required this.namaMatkul,
  });

  factory MatkulModel.fromJson(Map<String, dynamic> json) {
    return MatkulModel(
      idMatkul: json['id_matkul'],
      kodeMatkul: json["kode_matkul"],
      namaMatkul: json["nama_matkul"],
    );
  }
}
