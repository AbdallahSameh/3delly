import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class YoloService extends StatelessWidget {
  final Function(List<YOLOResult> result) onResult;
  const YoloService({super.key, required this.onResult});

  @override
  Widget build(BuildContext context) {
    return YOLOView(
      modelPath: 'assets/model/best_float32.tflite',
      task: YOLOTask.detect,
      onResult: onResult,
    );
  }
}
