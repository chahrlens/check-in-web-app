import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LocalStorage extends GetxController {
  late SharedPreferences _prefs;
  final Completer<void> _initCompleter = Completer<void>();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _ensureInitialized() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
  }
  Future<bool> isInitialized() async {
    return _initCompleter.isCompleted;
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _initCompleter.complete();
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> setStringValues(Map<String, String> values) async {
    await Future.wait(
      values.entries.map((entry) => _prefs.setString(entry.key, entry.value)),
    );
  }

  Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await _ensureInitialized();
    return _prefs.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs.getBool(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _ensureInitialized();
    await _prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    await _ensureInitialized();
    return _prefs.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    await _ensureInitialized();
    return _prefs.getStringList(key);
  }

  Future<void> removeElement(String key) async {
    await _ensureInitialized();
    await _prefs.remove(key);
  }
}
