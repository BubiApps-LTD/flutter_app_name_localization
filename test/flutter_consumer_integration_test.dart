import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('Flutter consumer builds', () {
    test(
      'works from dependencies',
      () {
        _verifyFlutterConsumerBuild(dependencySection: 'dependencies');
      },
      timeout: const Timeout(Duration(minutes: 20)),
    );

    test(
      'works from dev_dependencies',
      () {
        _verifyFlutterConsumerBuild(dependencySection: 'dev_dependencies');
      },
      timeout: const Timeout(Duration(minutes: 20)),
    );
  });
}

void _verifyFlutterConsumerBuild({required String dependencySection}) {
  final Directory tempDirectory = Directory.systemTemp.createTempSync(
    'flutter_app_name_localization_consumer',
  );
  final String appName = dependencySection == 'dependencies'
      ? 'consumer_dependencies'
      : 'consumer_dev_dependencies';
  final String appDirectory = path.join(tempDirectory.path, appName);

  runProcessOrFail(
    'flutter',
    <String>[
      'create',
      '--platforms=android',
      '--org',
      'com.example',
      appDirectory,
    ],
    workingDirectory: tempDirectory.path,
  );

  addPackageDependency(
    appDirectory: appDirectory,
    section: dependencySection,
    packagePath: packageRoot,
  );
  addLocalizationConfig(appDirectory);
  setManifestLabelToStringResource(appDirectory);

  runProcessOrFail(
    'flutter',
    <String>['pub', 'get'],
    workingDirectory: appDirectory,
  );
  runProcessOrFail(
    'dart',
    <String>['run', 'flutter_app_name_localization'],
    workingDirectory: appDirectory,
  );

  expect(
    readFile(
      path.join(
        appDirectory,
        'android',
        'app',
        'src',
        'main',
        'res',
        'values',
        'strings.xml',
      ),
    ),
    contains('My App'),
  );
  expect(
    readFile(
      path.join(
        appDirectory,
        'android',
        'app',
        'src',
        'main',
        'res',
        'values-tr',
        'strings.xml',
      ),
    ),
    contains('Benim Uygulamam'),
  );

  final File pluginsFile = File(
    path.join(appDirectory, '.flutter-plugins-dependencies'),
  );
  if (pluginsFile.existsSync()) {
    expect(
      pluginsFile.readAsStringSync(),
      isNot(contains('flutter_app_name_localization')),
    );
  }

  runProcessOrFail(
    'flutter',
    <String>['build', 'apk', '--release'],
    workingDirectory: appDirectory,
  );
  runProcessOrFail(
    'flutter',
    <String>['build', 'appbundle'],
    workingDirectory: appDirectory,
  );

  final File registrantFile = File(
    path.join(
      appDirectory,
      'android',
      'app',
      'src',
      'main',
      'java',
      'io',
      'flutter',
      'plugins',
      'GeneratedPluginRegistrant.java',
    ),
  );
  if (registrantFile.existsSync()) {
    expect(
      registrantFile.readAsStringSync(),
      isNot(contains('flutter_app_name_localization')),
    );
  }
}
