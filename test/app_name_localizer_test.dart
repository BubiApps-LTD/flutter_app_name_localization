import 'dart:io';

import 'package:flutter_app_name_localization/flutter_app_name_localization.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('AppNameLocalizer', () {
    test('creates localized strings files from the fixture project', () {
      final Directory projectDirectory = copyFixture('minimal_project');

      final AppNameLocalizationResult result = AppNameLocalizer.localize(
        pubspecPath: path.join(projectDirectory.path, 'pubspec.yaml'),
      );

      expect(result.updatedFiles, hasLength(3));
      expect(
        readFile(
          path.join(
            projectDirectory.path,
            'android',
            'app',
            'src',
            'main',
            'res',
            'values',
            'strings.xml',
          ),
        ),
        contains('Fixture App'),
      );
      expect(
        readFile(
          path.join(
            projectDirectory.path,
            'android',
            'app',
            'src',
            'main',
            'res',
            'values-tr',
            'strings.xml',
          ),
        ),
        contains('Fikstur Uygulamasi'),
      );
      expect(result.warnings, isEmpty);
    });

    test('updates existing strings.xml without removing unrelated entries', () {
      final Directory projectDirectory =
          copyFixture('existing_strings_project');

      AppNameLocalizer.localize(
        pubspecPath: path.join(projectDirectory.path, 'pubspec.yaml'),
      );

      final String stringsXml = readFile(
        path.join(
          projectDirectory.path,
          'android',
          'app',
          'src',
          'main',
          'res',
          'values',
          'strings.xml',
        ),
      );

      expect(stringsXml, contains('name="hello"'));
      expect(stringsXml, contains('Updated App'));
      expect(stringsXml, isNot(contains('Old App Name')));
    });

    test('returns a manifest warning for a hard-coded label', () {
      final Directory projectDirectory =
          copyFixture('existing_strings_project');

      final AppNameLocalizationResult result = AppNameLocalizer.localize(
        pubspecPath: path.join(projectDirectory.path, 'pubspec.yaml'),
      );

      expect(result.warnings, hasLength(1));
      expect(
          result.warnings.single, contains('android:label="@string/app_name"'));
    });
  });
}
