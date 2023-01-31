import 'dart:convert';
import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:path/path.dart';
import 'package:saaaltodos/tools/logger.dart';

final cwd = normalize(join(Platform.script.toFilePath(), '../'));
final sourceFolder = Directory(join(cwd, 'src'));
final distFolder = Directory(join(cwd, 'dist'));
const prefix = 'app_';

/// Arb files (for locale config) is not convenient to apply json schema.
/// Once json schema introduced, it will not available for flutter generate.
///
/// So just use json files to config, and then compile them into arb files
/// without `"$schema"` and other keys of non-camel-case.
/// And here is the script.
///
/// It can be called via `"locale"` command in npm.
///
void main() async {
  // Empty out folder.
  if (await distFolder.exists()) {
    await distFolder.delete(recursive: true);
    await distFolder.create(recursive: true);
    log.dev('dist folder emptied: ${distFolder.path}');
  } else {
    await distFolder.create(recursive: true);
  }

  // Process compilations.
  final List<Future<void>> tasks = [];
  final List<String> done = [];
  final Map<String, String> fail = {};

  for (final entity in await sourceFolder.list().toList()) {
    final path = entity.path;
    if ((await entity.stat()).type != FileSystemEntityType.file) return;
    if (path.split('.').last != 'json') return;
    tasks.add(
      processArb(File(path), outDir: distFolder, prefix: prefix)
          .then((out) => done.add(out))
          .catchError((Object err) => fail[path] = err.toString()),
    );
  }

  // Log results.
  log.dev('processing ${tasks.length} locale source files...');
  await Future.wait(tasks);

  log.success(
    'done: ${ratioDisplay(done.length, tasks.length)}',
    object: done.logFormat,
  );

  if (fail.isNotEmpty) {
    log.warn(
      'fail: ${ratioDisplay(fail.length, tasks.length)}',
      object: fail.logFormat,
    );
  }
}

/// Compile json file to valid arb file.
///
/// 1. All invalid keys will be removed.
/// 2. All available keys will be transformed into camelCase.
///
Future<String> processArb(
  File from, {
  Directory? outDir,
  String prefix = '',
}) async {
  outDir = outDir ?? from.parent;

  final raw = jsonDecode(await from.readAsString());
  if (raw is! Map<String, dynamic>) throw Exception('invalid src structure');

  final builder = <String, String>{};
  for (final key in raw.keys) {
    if (RegExp('[@\$]').hasMatch(key) || raw[key] is! String) continue;
    builder[key.toCamelCase()] = raw[key] as String;
  }

  // Process file path: from source to outDir, from .json to .arb
  final name = from.path.split(separator).last;
  final path = prefix +
      name.replaceRange(
        name.length - 'json'.length,
        null,
        'arb',
      );

  await File(join(outDir.path, path)).writeAsString(jsonEncode(builder));
  return path;
}
