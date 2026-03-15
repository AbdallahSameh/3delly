import 'package:camera/camera.dart';

class CameraService {
  CameraController? controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      controller = CameraController(cameras.first, ResolutionPreset.medium);

      await controller!.initialize().catchError((e) {
        if (e is CameraException) {
          print('Camera permission denied');
        }
      });
    }
  }

  bool notInitialized() =>
      controller == null || !controller!.value.isInitialized;

  Future<XFile> takePicture() async {
    return await controller!.takePicture();
  }

  Future<void> setFlash(bool on) async {
    await controller!.setFlashMode(on ? FlashMode.torch : FlashMode.off);
  }

  void dispose() {
    controller?.dispose();
  }
}
