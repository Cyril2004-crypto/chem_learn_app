import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static Future<void> init() async => await Hive.initFlutter();

  Future<Box> openBox(String name) async => await Hive.openBox(name);

  Future<void> save(String boxName, String key, dynamic value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  Future<dynamic> read(String boxName, String key) async {
    final box = await openBox(boxName);
    return box.get(key);
  }
}