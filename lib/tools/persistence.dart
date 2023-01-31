import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class MapConvert {
  Map<String, dynamic> get map;
  void fromMap(Map<String, dynamic> map);
}

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

abstract class Persistence {
  FutureOr<void> read();
  FutureOr<void> save();
}

abstract class JsonPersistence extends JsonConvert implements Persistence {
  JsonPersistence();

  File? file;

  @override
  Future<void> read() async {
    if (file == null) throw Exception('read from no file');
    fromJson(await file!.readAsString());
  }

  Future<void> readFile(File file) async => fromJson(await file.readAsString());

  @override
  Future<void> save() async {
    if (file == null) throw Exception('write into no file');
    await file?.writeAsString(this.json);
  }
}

T resolve<T>(dynamic raw, T defaultValue) => raw is T ? raw : defaultValue;
