enum NotificationType {
  presensiBerhasil,
  presensiGagal,
  presensiAkanHabis,
  pengumuman
}

class NotificationDetailModel {
  final String judul;
  final String tanggal;
  final String jam;
  final String keterangan;
  final NotificationType jenis;
  final String namaUser;

  NotificationDetailModel({
    required this.judul,
    required this.tanggal,
    required this.jam,
    required this.keterangan,
    required this.jenis,
    required this.namaUser,
  });
}
