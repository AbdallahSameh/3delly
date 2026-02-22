import 'package:dominos_counter/model_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Test the model', () async {
    var input = (await rootBundle.load(
      'assets/images/test1.jpeg',
    )).buffer.asUint8List();

    var output = List.generate(
      1,
      (_) => List.generate(8400, (_) => List.filled(85, 0.0)),
    );

    final modelService = ModelService();
    await modelService.loadModel();
    print(modelService.runModel(input, output));
    print(output);
  });
}

// void processImage() {

//   ImageProcessor imageProcessor = ImageProcessorBuilder()
//       .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
//       .build();

//   TensorImage tensorImage = TensorImage.fromFile(imageFile);
//   tensorImage = imageProcessor.process(tensorImage);
// }
