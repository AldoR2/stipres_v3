class TahunAjaranAktif {
  final int? id;
  final String? tahunAwal;
  final String? tahunAkhir;
  final String? keterangan;

  TahunAjaranAktif({
    required this.id,
    required this.tahunAwal,
    required this.tahunAkhir,
    required this.keterangan,
  });

  factory TahunAjaranAktif.fromJson(Map<String, dynamic> json) {
    return TahunAjaranAktif(
      id: json["id"],
      tahunAwal: json["tahun_awal"],
      tahunAkhir: json["tahun_akhir"],
      keterangan: json["keterangan"],
    );
  }
}
