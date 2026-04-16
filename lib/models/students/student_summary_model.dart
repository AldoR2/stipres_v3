class MahasiswaDashboardModel {
  final int totalKehadiran;
  final int presensiBerlangsung;
  final int jumlahJadwalAktif;
  final int jumlahKalenderAkademik;
  final int jumlahPresensiOnline;

  MahasiswaDashboardModel({
    required this.totalKehadiran,
    required this.presensiBerlangsung,
    required this.jumlahJadwalAktif,
    required this.jumlahKalenderAkademik,
    required this.jumlahPresensiOnline,
  });

  factory MahasiswaDashboardModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaDashboardModel(
      totalKehadiran: json['total_kehadiran'] ?? 0,
      presensiBerlangsung: json['presensi_berlangsung'] ?? 0,
      jumlahJadwalAktif: json['jumlah_jadwal_aktif'] ?? 0,
      jumlahKalenderAkademik: json['jumlah_kalender_akademik'] ?? 0,
      jumlahPresensiOnline: json['jumlah_presensi_online'] ?? 0,
    );
  }
}
