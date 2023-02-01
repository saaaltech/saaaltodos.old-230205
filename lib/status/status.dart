import 'package:change_case/change_case.dart';
import 'package:saaaltodos/status/app_root.dart';
import 'package:saaaltodos/tools/persistence.dart';

/// A global instance of [LocalStatus].
///
/// Don't forget to initialize by setting its file and local storage key,
/// or it will throw exceptions when reading and saving data.
///
final status = LocalStatus();

/// Local status about the app,
/// including user options and status about the app.
/// Close the app and open again, those data will be recovered.
///
class LocalStatus extends JsonPersistence {
  static final themeModeKey = 'theme mode'.toKebabCase();

  @override
  void fromMap(Map<String, dynamic> map) {
    appRootState?.themeModeFromName(map[themeModeKey]);
  }

  @override
  Map<String, dynamic> get map {
    return {
      themeModeKey: appRootState?.themeMode.name,
    };
  }
}