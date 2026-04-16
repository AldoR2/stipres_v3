class LecturerAllScheduleModel {
  final String? durasi;
  final String? hari;
  final String? namaMatkul;
  final String? kodeMatkul;
  final String? namaRuangan;
  final int? semester;
  final String? jam;
  String? durasiPerkuliahan;

  LecturerAllScheduleModel({
    required this.durasi,
    required this.hari,
    required this.namaMatkul,
    required this.kodeMatkul,
    required this.namaRuangan,
    required this.semester,
    required this.jam,
    this.durasiPerkuliahan,
  });

  factory LecturerAllScheduleModel.fromJson(Map<String, dynamic> json) {
    return LecturerAllScheduleModel(
      durasi: json["durasi"],
      hari: json["hari"],
      namaMatkul: json["nama_matkul"],
      kodeMatkul: json["kode_matkul"],
      namaRuangan: json["nama_ruangan"],
      semester: json["semester"],
      jam: json["jam"],
    );
  }
}
