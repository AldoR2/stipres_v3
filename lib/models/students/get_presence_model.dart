class GetPresenceApi {
   String? durasiPresensi;
   String? namaMatkul;
   String? kodeMatkul;
   DateTime? tglPresensi;

  GetPresenceApi({
    this.durasiPresensi,
    this.namaMatkul,
    this.kodeMatkul,
    this.tglPresensi,
  });

  factory GetPresenceApi.fromJson(Map<String, dynamic> json) {
    return GetPresenceApi(
      durasiPresensi: json["durasi_presensi"],
      namaMatkul: json["nama_matkul"],
      kodeMatkul: json["kode_matkul"],
      tglPresensi: DateTime.tryParse(json["tgl_presensi"] ?? ""),
    );
  }
}
