import 'dart:io';
import 'package:yaml/yaml.dart';

import 'flutter_app_name_localization_platform_interface.dart';

class FlutterAppNameLocalization {
  Future<String?> getPlatformVersion() {
    return FlutterAppNameLocalizationPlatform.instance.getPlatformVersion();
  }

  void updateAndroidAppName() {
    final pubspec = File('pubspec.yaml');
    final content = pubspec.readAsStringSync();
    final config = loadYaml(content)['flutter_app_name_localization'];

    final defaultName = config['default'];

    _updateAndroidManifest(defaultName);
  }

  void _updateAndroidManifest(String defaultName) {
    // Update AndroidManifest.xml
    final manifestFile = File('android/app/src/main/AndroidManifest.xml');
    var manifestContent = manifestFile.readAsStringSync();

    // Replace the default app name
    manifestContent = manifestContent.replaceAll(RegExp(r'android:label=".*?"'), 'android:label="$defaultName"');
    manifestFile.writeAsStringSync(manifestContent);
  }
}
