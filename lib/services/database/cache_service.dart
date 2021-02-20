import 'dart:developer';

import 'package:hive/hive.dart' as hive;

/* TODO: UPDATE THIS CACHE TO USE A LRU CACHE */
class CacheService {
  CacheService._();

  static const _boxName = 'CACHE_BOX';

  static Future<hive.Box> _openBox() => hive.Hive.openBox(_boxName);

  static Future<bool> exists(String url) async {
    hive.Box box = await _openBox();
    return box.containsKey(url);
  }

  static Future<String> get(String url) async {
    hive.Box box = await _openBox();
    return box.get(
      url,
      defaultValue: null,
    );
  }

  static Future<String> put(String url, String data) async {
    hive.Box box = await _openBox();
    await box.put(url, data);
    return data;
  }
}
