import 'package:camera/camera.dart';
import 'package:dominos_counter/services/camera_service.dart';
import 'package:dominos_counter/ui/painter/bounding_boxes_paint.dart';
import 'package:dominos_counter/ui/screens/results.dart';
import 'package:flutter/material.dart';

class CameraCard extends StatefulWidget {
  final CameraService cameraService;
  final bool cameraOn;
  final dynamic input;
  final List<Map<String, dynamic>> predictions;
  final int predictionsCount;

  const CameraCard({
    super.key,
    required this.cameraService,
    required this.cameraOn,
    required this.input,
    required this.predictions,
    required this.predictionsCount,
  });

  @override
  State<CameraCard> createState() => _CameraCardState();
}

class _CameraCardState extends State<CameraCard> {
  late Future<void> cameraFuture;
  bool flashOn = false;

  @override
  void initState() {
    super.initState();
    cameraFuture = widget.cameraService.initialize();
  }

  @override
  void dispose() {
    widget.cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/CameraCard.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(32, 50)),
        boxShadow: [BoxShadow(offset: Offset(0, 2), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7.2, 10, 7.2, 12),
        child: Stack(
          children: [
            FutureBuilder(
              future: cameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.elliptical(32, 50)),
                      child: LayoutBuilder(
                        builder: (context, boxConstraints) {
                          return widget.cameraOn
                              ? CameraPreview(widget.cameraService.controller!)
                              : Results(
                                  image: widget.input,
                                  painter: BoundingBoxesPaint(
                                    boxes: widget.predictions,
                                    previewSize: Size(
                                      widget
                                          .cameraService
                                          .controller!
                                          .value
                                          .previewSize!
                                          .height,
                                      widget
                                          .cameraService
                                          .controller!
                                          .value
                                          .previewSize!
                                          .width,
                                    ),
                                    windowSize: Size(
                                      boxConstraints.maxWidth,
                                      boxConstraints.maxHeight,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  );
                }
                return Center(child: Text('No Camera'));
              },
            ),

            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () async {
                  if (widget.cameraService.notInitialized()) return;

                  setState(() {
                    flashOn = !flashOn;
                  });

                  await widget.cameraService.setFlash(flashOn);
                },
                icon: flashOn
                    ? Icon(Icons.flash_on, color: Colors.white)
                    : Icon(Icons.flash_off, color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Text(
                  'Detected: ${widget.predictionsCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
