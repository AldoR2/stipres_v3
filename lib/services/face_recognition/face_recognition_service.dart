import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService extends GetxService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter =
        await Interpreter.fromAsset('assets/models/mobilefacenet.tflite');
  }

  Future<List<double>> generateEmbedding(img.Image image) async {
    final input = _imageToByteListFloat32(image);

    final output = List.generate(1, (_) => List.filled(192, 0.0));

    _interpreter.run(input, output);

    return List<double>.from(output[0]);
  }

  List<List<List<List<double>>>> _imageToByteListFloat32(img.Image image) {
    return [
      List.generate(
          112,
          (y) => List.generate(112, (x) {
                final pixel = image.getPixel(x, y);

                return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
              }))
    ];
  }
}
