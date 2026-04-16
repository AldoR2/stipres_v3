class PerkuliahanModel {
  final int semester;
  final String matkul;
  final String tanggal;
  final String dosen;
  final String jam;
  final String? linkZoom; // opsional

  PerkuliahanModel({
    required this.semester,
    required this.matkul,
    required this.tanggal,
    required this.dosen,
    required this.jam,
    this.linkZoom,
  });
}
