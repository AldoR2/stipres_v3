class AllScheduleModelApi {
  final String? durasi;
  final String? namaMatkul;
  final String? namaRuangan;
  final String? jam;
  final String? hari;
  String? durasiPerkuliahan;

  AllScheduleModelApi({
    required this.durasi,
    required this.namaMatkul,
    required this.namaRuangan,
    required this.jam,
    required this.hari,
    this.durasiPerkuliahan,
  });

  factory AllScheduleModelApi.fromJson(Map<String, dynamic> json) {
    return AllScheduleModelApi(
      durasi: json["durasi"],
      namaMatkul: json["nama_matkul"],
      namaRuangan: json["nama_ruangan"],
      jam: json["jam"],
      hari: json["hari"],
    );
  }
}
