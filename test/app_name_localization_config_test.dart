import 'package:flutter_app_name_localization/flutter_app_name_localization.dart';
import 'package:test/test.dart';

void main() {
  group('AppNameLocalizationConfig', () {
    test('parses a valid config', () {
      final AppNameLocalizationConfig config =
          AppNameLocalizationConfig.fromYamlString(
        '''
name: sample_app
flutter_app_name_localization:
  default: "My App"
  locales:
    - locale: "tr"
      name: "Benim Uygulamam"
    - locale: "de"
      name: "Meine App"
''',
      );

      expect(config.defaultName, 'My App');
      expect(
        config.locales,
        <String, String>{
          'tr': 'Benim Uygulamam',
          'de': 'Meine App',
        },
      );
    });

    test('throws when default is missing', () {
      expect(
        () => AppNameLocalizationConfig.fromYamlString(
          '''
name: sample_app
flutter_app_name_localization:
  locales:
    - locale: "tr"
      name: "Benim Uygulamam"
''',
        ),
        throwsA(
          isA<Exception>().having(
            (Object error) => error.toString(),
            'message',
            contains('flutter_app_name_localization.default'),
          ),
        ),
      );
    });

    test('supports missing locales', () {
      final AppNameLocalizationConfig config =
          AppNameLocalizationConfig.fromYamlString(
        '''
name: sample_app
flutter_app_name_localization:
  default: "My App"
''',
      );

      expect(config.defaultName, 'My App');
      expect(config.locales, isEmpty);
    });
  });
}
