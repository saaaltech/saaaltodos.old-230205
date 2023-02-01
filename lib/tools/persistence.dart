import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Convert between dart `class` and `Map<String, dynamic>`,
/// prepare for converts with `json`, `yaml`, ext.
///
abstract class MapConvert {
  Map<String, dynamic> get map;
  void fromMap(Map<String, dynamic> map);
}

/// Convert between dart class and json string.
abstract class JsonConvert extends MapConvert {
  String get json => jsonEncode(map);

  void fromJson(String json) {
    final map = jsonDecode(json);
    if (map is! Map<String, dynamic>) {
      throw Exception('invalid json structure: not a json object');
    }
    fromMap(map);
  }
}

/// Data persistence interface.
abstract class Persistence {
  FutureOr<void> read();
  FutureOr<void> save();
}

/// Using file or browser local storage for data persistence.
/// The data will be stored in json format.
///
/// It will use a given [file] to storage the data in native platforms
/// and it will store the data into local storage with given [localStorageKey].
/// Those two variables must not be `null` or an exception will be thrown
/// when [save] or [read].
///
abstract class JsonPersistence extends JsonConvert implements Persistence {
  JsonPersistence();

  File? file;
  String? localStorageKey;

  @override
  Future<void> read() async {
    if (kIsWeb) {
      // read web local storage.
    } else {
      if (file == null) throw Exception('read from no file');
      fromJson(await file!.readAsString());
    }
  }

  @override
  Future<void> save() async {
    if (kIsWeb) {
      // save into web local storage.
    } else {
      if (file == null) throw Exception('write into no file');
      await file?.writeAsString(this.json);
    }
  }
}

T resolve<T>(dynamic raw, T defaultValue) => raw is T ? raw : defaultValue;
