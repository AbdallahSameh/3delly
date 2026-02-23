import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/best_float32.tflite',
      );
    } catch (e) {
      throw Exception("Model loading failed: $e");
    }
  }

  List<dynamic> runModel(Uint8List imageBytes) {
    if (_interpreter == null) {
      throw Exception("Interpreter not loaded");
    }

    final input = preprocessImage(imageBytes);

    var output = List.filled(1 * 5 * 8400, 0.0).reshape([1, 5, 8400]);

    _interpreter!.run(input, output);

    return output;
  }

  Float32List preprocessImage(Uint8List imageBytes) {
    var inputShape = _interpreter!.getInputTensor(0).shape;
    int inputSize = inputShape[1];

    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Unable to decode image");
    }

    img.Image resized = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );

    final Float32List tensor = Float32List(1 * inputSize * inputSize * 3);

    int index = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = resized.getPixelSafe(x, y);

        tensor[index++] = pixel.r / 255.0;
        tensor[index++] = pixel.g / 255.0;
        tensor[index++] = pixel.b / 255.0;
      }
    }

    debugPrint("Preprocess debug:");
    debugPrint("Input size: $inputSize");
    debugPrint("Tensor length: ${tensor.length}");
    debugPrint("Expected length: ${1 * inputSize * inputSize * 3}");
    return tensor;
  }

  void close() {
    _interpreter?.close();
  }
}
