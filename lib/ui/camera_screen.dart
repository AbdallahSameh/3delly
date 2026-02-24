import 'package:camera/camera.dart';
import 'package:dominos_counter/model_service.dart';
import 'package:dominos_counter/yolo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  final modelService = ModelService();
  CameraController? controller;
  List<YOLOResult> predictions = [];
  late Future<void> loaded;

  initCamera() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        controller = CameraController(cameras[0], ResolutionPreset.medium);
        controller!
            .initialize()
            .then((_) {
              if (!mounted) {
                return;
              }
              setState(() {});
            })
            .catchError((e) {
              if (e is CameraException) {
                print('Camera permission denied');
              }
            });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    initCamera();
    loaded = modelService.loadModel();
  }

  @override
  void dispose() {
    controller?.dispose();
    modelService.close();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            // child: controller == null || !controller!.value.isInitialized
            //     ? Center(child: CircularProgressIndicator())
            //     : CameraPreview(controller!),
            child: YoloService(
              onResult: (result) {
                setState(() {
                  predictions = result;
                });
                print('Found ${predictions.length} objects!');
                for (final result in predictions) {
                  print('${result.className}: ${result.confidence}');
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Text(
                        '${predictions[index].className}: ${predictions[index].confidence}',
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 12);
                    },
                    itemCount: predictions.length,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // await loaded;
                    // var input = (await rootBundle.load(
                    //   'assets/images/test1.jpeg',
                    // )).buffer.asUint8List();

                    // modelService.runModel(input);
                    print('Found ${predictions.length} objects!');
                    for (final result in predictions) {
                      print('${result.className}: ${result.confidence}');
                    }
                  },
                  child: Text('Run Model'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
