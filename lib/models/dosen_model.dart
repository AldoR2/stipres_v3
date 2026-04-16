class Dosen {
  final String nama;
  final String nip;
  final String email;
  final String? status;
  final String? message;

  Dosen({
    this.status,
    this.message,
    required this.nip,
    required this.nama,
    required this.email,
    // required this.prodi,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      nip: json['nip'], nama: json['nama'], email: json['email'],
      status: json['status'], // Ambil dari root JSON
      message: json['message'], // Ambil dari root JSON
    );
    // prodi: json['prodi']);
  }

  Map<String, dynamic> toJson() => {
        nip: 'nip',
        nama: 'nama',
        email: 'email',
        // prodi: 'prodi',
      };
}
