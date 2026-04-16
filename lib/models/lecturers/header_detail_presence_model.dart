class HeaderDetailPresensi {
    final String namaMatkul;
    final String durasiPresensi;
    final String namaProdi;

    HeaderDetailPresensi({
        required this.namaMatkul,
        required this.durasiPresensi,
        required this.namaProdi,
    });

    factory HeaderDetailPresensi.fromJson(Map<String, dynamic> json){ 
        return HeaderDetailPresensi(
            namaMatkul: json["nama_matkul"],
            durasiPresensi: json["durasi_presensi"],
            namaProdi: json["nama_prodi"],
        );
    }

}
