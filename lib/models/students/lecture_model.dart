class LectureModelApi {
  final int presensisId;
  final String namaMatkul;
  final int semester;
  final String durasiPresensi;
  String? namaDosen;
  String? linkZoom;
  String tglPresensi;

  LectureModelApi({
    required this.presensisId,
    required this.namaMatkul,
    required this.semester,
    required this.durasiPresensi,
    this.namaDosen,
    required this.linkZoom,
    required this.tglPresensi,
  });

  factory LectureModelApi.fromJson(Map<String, dynamic> json) {
    return LectureModelApi(
      namaMatkul: json["nama_matkul"],
      presensisId: json["presensi_id"],
      semester: json["semester"],
      durasiPresensi: json["durasi_presensi"],
      namaDosen: json["nama_dosen"],
      linkZoom: json["link_zoom"] ?? "Kosong",
      tglPresensi: json["tgl_presensi"],
    );
  }
}
