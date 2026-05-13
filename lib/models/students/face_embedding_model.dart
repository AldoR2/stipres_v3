class FaceEmbeddingModel {
  final int mahasiswaId;
  final List<double> embedding;

  FaceEmbeddingModel({required this.mahasiswaId, required this.embedding});

  Map<String, dynamic> toJson() {
    return {"mahasiswa_id": mahasiswaId, "embedding": embedding};
  }
}
