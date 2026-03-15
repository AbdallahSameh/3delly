import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<String> getLogs() {
    return _prefs?.getStringList('logs') ?? [];
  }

  int getScore() {
    return _prefs?.getInt('score') ?? 0;
  }

  Future<void> saveLogs(List<String> logs) async {
    await _prefs?.setStringList('logs', logs);
  }

  Future<void> saveScore(int score) async {
    await _prefs?.setInt('score', score);
  }

  Future<void> resetLogs() async {
    await _prefs?.setStringList('logs', []);
  }

  Future<void> resetScore() async {
    await _prefs?.setInt('score', 0);
  }
}
