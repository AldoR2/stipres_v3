class EventCalendar {
  final int id;
  final String judul;
  final String? deskripsi;
  final DateTime tanggalMulai;
  final DateTime? tanggalSelesai;
  final int status; // 1 = Libur, 2 = Kegiatan

  EventCalendar({
    required this.id,
    required this.judul,
    this.deskripsi,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.status,
  });

  factory EventCalendar.fromJson(Map<String, dynamic> json) {
    return EventCalendar(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.parse(json['tanggal_selesai'])
          : null,
      status: json['status'],
    );
  }

  String get type => status == 1 ? 'Kegiatan' : 'Libur';
}
