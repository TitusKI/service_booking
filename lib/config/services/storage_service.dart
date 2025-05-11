import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final _box = GetStorage();

  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  bool isFirstTime() {
    return !(_box.read('onboardingCompleted') ?? false);
  }

  bool isLoggedIn() {
    return _box.read('isLoggedIn') ?? false;
  }

  Future<void> setBool(String key, bool value) async {
    await _box.write(key, value);
  }

  bool getBool(String key) {
    return _box.read(key) ?? false;
  }

  Future<void> setString(String key, String value) async {
    await _box.write(key, value);
  }

  String getString(String key) {
    return _box.read(key) ?? '';
  }

  Future<void> clearAll() async {
    await _box.erase();
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> logout() async {
    await _box.remove('isLoggedIn');
  }
}
