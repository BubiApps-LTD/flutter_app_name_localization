import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_app_name_localization_method_channel.dart';

abstract class FlutterAppNameLocalizationPlatform extends PlatformInterface {
  /// Constructs a FlutterAppNameLocalizationPlatform.
  FlutterAppNameLocalizationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAppNameLocalizationPlatform _instance = MethodChannelFlutterAppNameLocalization();

  /// The default instance of [FlutterAppNameLocalizationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAppNameLocalization].
  static FlutterAppNameLocalizationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAppNameLocalizationPlatform] when
  /// they register themselves.
  static set instance(FlutterAppNameLocalizationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
