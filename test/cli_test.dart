import 'dart:io';

import 'package:flutter_app_name_localization/src/cli.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('runCli', () {
    test('returns a non-zero exit code for invalid config', () async {
      final Directory projectDirectory = copyFixture('minimal_project');
      writeFile(
        path.join(projectDirectory.path, 'pubspec.yaml'),
        '''
name: sample_app
flutter_app_name_localization:
  locales:
    - locale: "tr"
      name: "Benim Uygulamam"
''',
      );

      final List<String> stdoutLines = <String>[];
      final List<String> stderrLines = <String>[];
      final int exitCode = runCli(
        <String>['--config', path.join(projectDirectory.path, 'pubspec.yaml')],
        stdoutWriter: stdoutLines.add,
        stderrWriter: stderrLines.add,
      );

      expect(exitCode, isNot(0));
      expect(stdoutLines, isEmpty);
      expect(stderrLines.single,
          contains('flutter_app_name_localization.default'));
    });

    test('updates the project referenced by --config', () {
      final Directory projectDirectory = copyFixture('minimal_project');

      final int exitCode = runCli(
        <String>['--config', path.join(projectDirectory.path, 'pubspec.yaml')],
      );

      expect(exitCode, 0);
      expect(
        File(
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
        ).existsSync(),
        isTrue,
      );
    });
  });
}
