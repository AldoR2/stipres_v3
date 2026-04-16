class JadwalModelApi {
  String presensiId;
  int presensisId;
  String waktu;
  final String mataKuliah;
  String? lokasi;
  String durasiMatkul;
  String? keterangan;
  String? namaDosen;
  String? kodeMatkul;
  String? tglPresensi;

  JadwalModelApi({
    required this.presensiId,
    required this.presensisId,
    required this.waktu,
    required this.mataKuliah,
    this.lokasi,
    required this.durasiMatkul,
    this.keterangan,
    required this.namaDosen,
    required this.kodeMatkul,
    required this.tglPresensi,
  });

  factory JadwalModelApi.fromJson(Map<String, dynamic> json) {
    return JadwalModelApi(
        presensiId: json['presensi_id'],
        presensisId: json['presensis_id'],
        waktu: json['durasi_presensi'],
        mataKuliah: json['nama_matkul'],
        lokasi: json['nama_ruangan'],
        durasiMatkul: json['durasi_matkul'],
        namaDosen: json['nama_dosen'],
        kodeMatkul: json['kode_matkul'],
        tglPresensi: json['tgl_presensi']
        );
  }
}
