import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

import 'app_name_localization_config.dart';
import 'app_name_localization_exception.dart';
import 'app_name_localization_result.dart';

const String _appNameResourceKey = 'app_name';

/// Updates Android `strings.xml` resources from `flutter_app_name_localization`.
class AppNameLocalizer {
  static AppNameLocalizationResult localize({
    required String pubspecPath,
    bool validateManifest = true,
  }) {
    final String resolvedPubspecPath = _resolvePath(pubspecPath);
    final File pubspecFile = File(resolvedPubspecPath);
    if (!pubspecFile.existsSync()) {
      throw AppNameLocalizationException(
        'The pubspec.yaml file does not exist: $resolvedPubspecPath',
      );
    }

    final String projectDirectory = pubspecFile.parent.absolute.path;
    final AppNameLocalizationConfig config =
        AppNameLocalizationConfig.fromYamlString(
            pubspecFile.readAsStringSync());

    final Directory mainSourceDirectory = Directory(
      path.join(projectDirectory, 'android', 'app', 'src', 'main'),
    );
    if (!mainSourceDirectory.existsSync()) {
      throw AppNameLocalizationException(
        'The Android main source directory does not exist: ${mainSourceDirectory.path}',
      );
    }
    final Directory resDirectory = Directory(
      path.join(mainSourceDirectory.path, 'res'),
    );
    resDirectory.createSync(recursive: true);

    final List<String> updatedFiles = <String>[
      _updateStringsXml(
        resDirectory: resDirectory,
        resourceDirectoryName: 'values',
        value: config.defaultName,
      ),
    ];

    for (final MapEntry<String, String> locale in config.locales.entries) {
      updatedFiles.add(
        _updateStringsXml(
          resDirectory: resDirectory,
          resourceDirectoryName: 'values-${locale.key}',
          value: locale.value,
        ),
      );
    }

    final List<String> warnings = <String>[];
    if (validateManifest) {
      final String manifestPath = path.join(
        projectDirectory,
        'android',
        'app',
        'src',
        'main',
        'AndroidManifest.xml',
      );
      final String? warning = _validateManifest(manifestPath);
      if (warning != null) {
        warnings.add(warning);
      }
    }

    return AppNameLocalizationResult(
      pubspecPath: resolvedPubspecPath,
      projectDirectory: projectDirectory,
      config: config,
      updatedFiles: updatedFiles,
      warnings: warnings,
    );
  }

  static String _resolvePath(String inputPath) {
    if (path.isAbsolute(inputPath)) {
      return path.normalize(inputPath);
    }
    return path.normalize(path.absolute(inputPath));
  }

  static String _updateStringsXml({
    required Directory resDirectory,
    required String resourceDirectoryName,
    required String value,
  }) {
    final Directory targetDirectory = Directory(
      path.join(resDirectory.path, resourceDirectoryName),
    );
    targetDirectory.createSync(recursive: true);

    final File file = File(path.join(targetDirectory.path, 'strings.xml'));
    final XmlDocument document = _loadOrCreateStringsDocument(file);
    final XmlElement resourcesElement =
        document.getElement('resources') ?? _appendResourcesElement(document);

    final Iterable<XmlElement> stringElements =
        resourcesElement.findElements('string');
    XmlElement? appNameElement;
    for (final XmlElement element in stringElements) {
      if (element.getAttribute('name') == _appNameResourceKey) {
        appNameElement = element;
        break;
      }
    }

    if (appNameElement == null) {
      final XmlBuilder builder = XmlBuilder();
      builder.element('string', nest: () {
        builder.attribute('name', _appNameResourceKey);
        builder.text(value);
      });
      resourcesElement.children.add(builder.buildFragment());
    } else {
      appNameElement.innerText = value;
    }

    try {
      file.writeAsStringSync(document.toXmlString(pretty: true, indent: '  '));
    } on FileSystemException catch (error) {
      throw AppNameLocalizationException(
        'Failed to write ${file.path}: ${error.message}',
      );
    }

    return file.absolute.path;
  }

  static XmlDocument _loadOrCreateStringsDocument(File file) {
    if (!file.existsSync()) {
      return XmlDocument.parse('<resources/>');
    }

    try {
      return XmlDocument.parse(file.readAsStringSync());
    } on XmlParserException catch (error) {
      throw AppNameLocalizationException(
        'Failed to parse ${file.path}: $error',
      );
    }
  }

  static XmlElement _appendResourcesElement(XmlDocument document) {
    if (document.children.isNotEmpty) {
      throw const AppNameLocalizationException(
        'strings.xml must use <resources> as the root element.',
      );
    }
    final XmlElement resourcesElement = XmlElement(XmlName('resources'));
    document.children.add(resourcesElement);
    return resourcesElement;
  }

  static String? _validateManifest(String manifestPath) {
    final File manifestFile = File(manifestPath);
    if (!manifestFile.existsSync()) {
      throw AppNameLocalizationException(
        'The Android manifest does not exist: $manifestPath',
      );
    }

    final XmlDocument document;
    try {
      document = XmlDocument.parse(manifestFile.readAsStringSync());
    } on XmlParserException catch (error) {
      throw AppNameLocalizationException(
        'Failed to parse $manifestPath: $error',
      );
    }

    final Iterator<XmlElement> iterator =
        document.findAllElements('application').iterator;
    if (!iterator.moveNext()) {
      throw AppNameLocalizationException(
        'The Android manifest is missing an <application> element: $manifestPath',
      );
    }

    final XmlElement applicationElement = iterator.current;
    String? label;
    for (final XmlAttribute attribute in applicationElement.attributes) {
      if (attribute.name.local == 'label' &&
          attribute.name.prefix == 'android') {
        label = attribute.value;
        break;
      }
    }

    if (label == '@string/app_name') {
      return null;
    }

    final String relativeManifestPath = path.relative(
      manifestPath,
      from: Directory.current.path,
    );
    return 'Set android:label="@string/app_name" in '
        '$relativeManifestPath to use the generated localized app names.';
  }
}
