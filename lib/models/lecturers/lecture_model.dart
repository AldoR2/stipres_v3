class LecturerLectureModel {
  final String namaMatkul;
  final int semester;
  final String durasiPresensi;
  String? namaDosen;
  final String linkZoom;
  String tglPresensi;

  LecturerLectureModel({
    required this.namaMatkul,
    required this.semester,
    required this.durasiPresensi,
    this.namaDosen,
    required this.linkZoom,
    required this.tglPresensi,
  });

  factory LecturerLectureModel.fromJson(Map<String, dynamic> json) {
    return LecturerLectureModel(
      namaMatkul: json["nama_matkul"],
      semester: json["semester"],
      durasiPresensi: json["durasi_presensi"],
      namaDosen: json["nama_dosen"],
      linkZoom: json["link_zoom"],
      tglPresensi: json["tgl_presensi"],
    );
  }
}
