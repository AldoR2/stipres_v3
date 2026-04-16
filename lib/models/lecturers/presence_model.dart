class PresensiDosenModel {
  final int semester;
  final int presensisId;
  final String jamAwal;
  final String jamAkhir;
  final String namaMatkul;
  final String kodeMatkul;
  String? durasiPresensi;
  final String durasiMatkul;

  PresensiDosenModel({
    required this.semester,
    required this.presensisId,
    required this.jamAwal,
    required this.jamAkhir,
    required this.namaMatkul,
    required this.kodeMatkul,
    required this.durasiMatkul,
    this.durasiPresensi,
  });

  factory PresensiDosenModel.fromJson(Map<String, dynamic> json) {
    return PresensiDosenModel(
      semester: json["semester"],
      presensisId: json["presensis_id"],
      jamAwal: json["jam_awal"],
      jamAkhir: json["jam_akhir"],
      namaMatkul: json["nama_matkul"],
      kodeMatkul: json["kode_matkul"],
      durasiMatkul: json["durasi_matkul"],
    );
  }
}
