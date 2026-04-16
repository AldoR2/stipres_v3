class DosenDashboardModel {
  final int jumlahMahasiswa;
  final int presensiHariIni;
  final int jumlahJadwalAktif;
  final int jumlahKalenderAkademik;
  final int perkuliahanOnlineHariIni;

  DosenDashboardModel({
    required this.jumlahMahasiswa,
    required this.presensiHariIni,
    required this.jumlahJadwalAktif,
    required this.jumlahKalenderAkademik,
    required this.perkuliahanOnlineHariIni,
  });

  factory DosenDashboardModel.fromJson(Map<String, dynamic> json) {
    return DosenDashboardModel(
      jumlahMahasiswa: json['jumlah_mahasiswa'] ?? 0,
      presensiHariIni: json['presensi_hari_ini'] ?? 0,
      jumlahJadwalAktif: json['jumlah_jadwal_aktif'] ?? 0,
      jumlahKalenderAkademik: json['jumlah_kalender_akademik'] ?? 0,
      perkuliahanOnlineHariIni: json['perkuliahan_online_hari_ini'] ?? 0,
    );
  }
}
