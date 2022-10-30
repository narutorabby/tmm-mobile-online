import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage{
  static const secureDataStorage = FlutterSecureStorage();

  static Future setStorageData(String key, String value) async => await secureDataStorage.write(key: key, value: value);

  static Future<String?> getStorageData(String key) async => await secureDataStorage.read(key: key);

  static Future deleteStorageData(String key) async => await secureDataStorage.delete(key: key);

  static Future deleteAllStorageData() async => await secureDataStorage.deleteAll();
}