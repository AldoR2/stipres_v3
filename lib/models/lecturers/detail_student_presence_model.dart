class DetailMahasiswaPresensi {
  final int? status;
  String? keterangan;
  final DateTime? waktuPresensi;
  String? waktu;
  final String? alasan;
  final String? bukti;

  DetailMahasiswaPresensi({
    required this.status,
    this.keterangan,
    required this.waktuPresensi,
    this.waktu,
    required this.alasan,
    required this.bukti,
  });

  factory DetailMahasiswaPresensi.fromJson(Map<String, dynamic> json) {
    return DetailMahasiswaPresensi(
      status: json["status"],
      waktuPresensi: DateTime.tryParse(json["waktu_presensi"] ?? ""),
      alasan: json["alasan"],
      bukti: json["bukti"],
    );
  }
}
