import 'dart:math';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FaceComparaterService extends GetxService {
  Logger log = Logger();
  double cosineSimiliarity(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) {
      log.d(
          "Panjang embedding tidak sama. Embedding1: ${embedding1.length}, Embedding2: ${embedding2.length},");
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      normA += embedding1[i] * embedding1[i];
      normB += embedding2[i] * embedding2[i];
    }

    if (normA == 0 || normB == 0) {
      return 0.0;
    }

    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  bool isMatch({
    required List<double> currentEmbedding,
    required List<double> registeredEmbedding,
    double threshold = 0.75,
  }) {
    final similarity = cosineSimiliarity(currentEmbedding, registeredEmbedding);

    return similarity >= threshold;
  }

  FaceCompareResult compare({
    required List<double> currentEmbedding,
    required List<double> registeredEmbedding,
    double threshold = 0.75,
  }) {
    final similarity = cosineSimiliarity(currentEmbedding, registeredEmbedding);

    return FaceCompareResult(
        similarity: similarity,
        threshold: threshold,
        isMatch: similarity >= threshold);
  }
}

class FaceCompareResult {
  final double similarity;
  final double threshold;
  final bool isMatch;

  FaceCompareResult({
    required this.similarity,
    required this.threshold,
    required this.isMatch,
  });
}
