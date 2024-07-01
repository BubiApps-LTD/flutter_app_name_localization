import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_name_localization/flutter_app_name_localization.dart';
import 'package:flutter_app_name_localization/flutter_app_name_localization_platform_interface.dart';
import 'package:flutter_app_name_localization/flutter_app_name_localization_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAppNameLocalizationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAppNameLocalizationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAppNameLocalizationPlatform initialPlatform = FlutterAppNameLocalizationPlatform.instance;

  test('$MethodChannelFlutterAppNameLocalization is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAppNameLocalization>());
  });

  test('getPlatformVersion', () async {
    FlutterAppNameLocalization flutterAppNameLocalizationPlugin = FlutterAppNameLocalization();
    MockFlutterAppNameLocalizationPlatform fakePlatform = MockFlutterAppNameLocalizationPlatform();
    FlutterAppNameLocalizationPlatform.instance = fakePlatform;

    expect(await flutterAppNameLocalizationPlugin.getPlatformVersion(), '42');
  });
}
