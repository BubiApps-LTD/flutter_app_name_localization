import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

final String packageRoot = path.normalize(Directory.current.path);

Directory copyFixture(String fixtureName) {
  final Directory source = Directory(
    path.join(packageRoot, 'test', 'fixtures', fixtureName),
  );
  final Directory target = Directory.systemTemp.createTempSync(
    'flutter_app_name_localization_$fixtureName',
  );
  _copyDirectory(source, target);
  return target;
}

void writeFile(String filePath, String contents) {
  final File file = File(filePath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(contents);
}

String readFile(String filePath) => File(filePath).readAsStringSync();

ProcessResult runProcessOrFail(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  Map<String, String>? environment,
  bool allowFailure = false,
}) {
  final ProcessResult result = Process.runSync(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
  );

  if (!allowFailure && result.exitCode != 0) {
    fail(
      'Command failed: $executable ${arguments.join(' ')}\n'
      'exitCode: ${result.exitCode}\n'
      'stdout:\n${result.stdout}\n'
      'stderr:\n${result.stderr}',
    );
  }

  return result;
}

void addPackageDependency({
  required String appDirectory,
  required String section,
  required String packagePath,
}) {
  final File pubspecFile = File(path.join(appDirectory, 'pubspec.yaml'));
  final String content = pubspecFile.readAsStringSync();
  final String packageBlock = '  flutter_app_name_localization:\n'
      '    path: ${jsonEncode(packagePath)}\n';

  late final String updatedContent;
  if (section == 'dependencies') {
    updatedContent = content.replaceFirst(
      'dependencies:\n  flutter:\n    sdk: flutter\n',
      'dependencies:\n  flutter:\n    sdk: flutter\n\n$packageBlock',
    );
  } else {
    updatedContent = content.replaceFirst(
      'dev_dependencies:\n  flutter_test:\n    sdk: flutter\n',
      'dev_dependencies:\n$packageBlock  flutter_test:\n    sdk: flutter\n',
    );
  }

  pubspecFile.writeAsStringSync(updatedContent);
}

void addLocalizationConfig(String appDirectory) {
  final File pubspecFile = File(path.join(appDirectory, 'pubspec.yaml'));
  pubspecFile.writeAsStringSync(
    '${pubspecFile.readAsStringSync()}\n'
    'flutter_app_name_localization:\n'
    '  default: "My App"\n'
    '  locales:\n'
    '    - locale: "tr"\n'
    '      name: "Benim Uygulamam"\n'
    '    - locale: "de"\n'
    '      name: "Meine App"\n',
  );
}

void setManifestLabelToStringResource(String appDirectory) {
  final File manifestFile = File(
    path.join(
      appDirectory,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    ),
  );
  final String updatedManifest = manifestFile.readAsStringSync().replaceFirst(
      RegExp('android:label="[^"]+"'), 'android:label="@string/app_name"');
  manifestFile.writeAsStringSync(updatedManifest);
}

void _copyDirectory(Directory source, Directory target) {
  for (final FileSystemEntity entity in source.listSync(recursive: true)) {
    final String relativePath = path.relative(entity.path, from: source.path);
    final String destinationPath = path.join(target.path, relativePath);

    if (entity is Directory) {
      Directory(destinationPath).createSync(recursive: true);
    } else if (entity is File) {
      File(destinationPath)
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(entity.readAsBytesSync());
    }
  }
}
