class GetPresenceApi {
   String? durasiPresensi;
   String? namaMatkul;
   String? kodeMatkul;
   DateTime? tglPresensi;
   final int? lokasiId;
   final String? namaLokasi;

  GetPresenceApi({
    this.durasiPresensi,
    this.namaMatkul,
    this.kodeMatkul,
    this.tglPresensi,
    this.lokasiId,
    this.namaLokasi,
  });

  factory GetPresenceApi.fromJson(Map<String, dynamic> json) {
    return GetPresenceApi(
      durasiPresensi: json["durasi_presensi"],
      namaMatkul: json["nama_matkul"],
      kodeMatkul: json["kode_matkul"],
      tglPresensi: DateTime.tryParse(json["tgl_presensi"] ?? ""),
      lokasiId: json["lokasi_id"],
      namaLokasi: json["nama_lokasi"],
    );
  }
}
