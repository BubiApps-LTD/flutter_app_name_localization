import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_app_name_localization_platform_interface.dart';

/// An implementation of [FlutterAppNameLocalizationPlatform] that uses method channels.
class MethodChannelFlutterAppNameLocalization extends FlutterAppNameLocalizationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_app_name_localization');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
