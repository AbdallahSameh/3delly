import 'dart:convert';
import 'package:dominos_counter/models/log.dart';
import 'package:dominos_counter/services/camera_service.dart';
import 'package:dominos_counter/services/storage_service.dart';
import 'package:dominos_counter/ui/shared/golden_button.dart';
import 'package:dominos_counter/services/yolo_service.dart';
import 'package:dominos_counter/ui/widgets/camera_card.dart';
import 'package:dominos_counter/ui/widgets/logs_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late YoloService yoloService;
  late final Future<void> initialized;
  List<Map<String, dynamic>> predictions = [];
  int predictionsCount = 0;
  bool cameraOn = true;
  var input;
  late Size previewSize;
  bool flashOn = false;
  StorageService storageService = StorageService();
  CameraService cameraService = CameraService();
  List<String> logs = [];
  int score = 0;

  Future<void> initStorage() async {
    await storageService.init();

    setState(() {
      logs = storageService.getLogs();
      score = storageService.getScore();
    });
  }

  Future<void> initCamera() async {
    await cameraService.initialize();
  }

  @override
  void initState() {
    super.initState();
    yoloService = YoloService();
    initialized = yoloService.initializeModel();
    initCamera();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    cameraService.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 40),
        drawer: LogsDrawer(
          storageService: storageService,
          logs: logs,
          score: score,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/BackgroundImage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CameraCard(
                      cameraService: cameraService,
                      cameraOn: cameraOn,
                      input: input,
                      predictions: predictions,
                      predictionsCount: predictionsCount,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 210,
                              height: 85,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/ScoreBoard(stretched_to_the_limit).png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfff7d98a),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GoldenButton(
                                size: Size(125, 40),
                                onPressed: () {
                                  setState(() {
                                    predictionsCount++;
                                  });
                                },
                                child: Icon(Icons.add),
                              ),
                              GoldenButton(
                                size: Size(125, 40),
                                onPressed: () {
                                  setState(() {
                                    predictionsCount--;
                                  });
                                },
                                child: Icon(Icons.remove),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GoldenButton(
                                size: Size(125, 40),
                                onPressed: () async {
                                  Log log = Log(
                                    count: predictionsCount,
                                    time: DateTime.now(),
                                  );

                                  logs.add(jsonEncode(log.toJson()));
                                  score += predictionsCount;
                                  predictionsCount = 0;

                                  cameraOn = true;

                                  await storageService.saveScore(score);
                                  await storageService.saveLogs(logs);
                                  setState(() {
                                    score = storageService.getScore();
                                    logs = storageService.getLogs();
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    Icon(Icons.photo_camera),
                                    Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GoldenButton(
                                size: Size(125, 40),
                                onPressed: () {
                                  setState(() {
                                    cameraOn = true;
                                    predictionsCount = 0;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    Icon(Icons.cancel),
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 300,
                            height: 55,
                            child: GoldenButton(
                              onPressed: () async {
                                await initialized;
                                input = await cameraService.takePicture();

                                final results = await yoloService.detectObjects(
                                  await input.readAsBytes(),
                                );

                                yoloService.boundingBoxes(results);
                                setState(() {
                                  predictions = results;
                                  predictionsCount = results.length;
                                  cameraOn = false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  Icon(Icons.photo_camera),
                                  Text(
                                    'Take Picture',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
