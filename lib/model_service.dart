import 'package:tflite_flutter/tflite_flutter.dart';

class ModelService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/model/best_float32.tflite',
    );
  }

  List<dynamic> runModel(input, output) {
    _interpreter.run(input, output);
    return output;
  }

  void close() {
    _interpreter.close();
  }
}
