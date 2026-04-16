class CheckPresenceModel {
  final DateTime? tanggalPresensi;
  final String? durasiPresensi;

  CheckPresenceModel({
    required this.tanggalPresensi,
    required this.durasiPresensi,
  });

  factory CheckPresenceModel.fromJson(Map<String, dynamic> json) {
    return CheckPresenceModel(
      tanggalPresensi: DateTime.tryParse(json["tanggal_presensi"] ?? ""),
      durasiPresensi: json["durasi_presensi"],
    );
  }
}
