import 'package:yaml/yaml.dart';

import 'app_name_localization_exception.dart';

const String _configSectionName = 'flutter_app_name_localization';

/// Parsed configuration from a Flutter project's `pubspec.yaml`.
class AppNameLocalizationConfig {
  AppNameLocalizationConfig({
    required this.defaultName,
    Map<String, String>? locales,
  }) : locales = Map.unmodifiable(locales ?? const <String, String>{});

  /// The default Android app name written to `values/strings.xml`.
  final String defaultName;

  /// Additional Android resource qualifiers mapped to localized app names.
  final Map<String, String> locales;

  factory AppNameLocalizationConfig.fromYamlString(String yamlSource) {
    final Object? document;
    try {
      document = loadYaml(yamlSource);
    } on YamlException catch (error) {
      throw AppNameLocalizationException(
        'Failed to parse pubspec.yaml: $error',
      );
    }

    if (document is! YamlMap) {
      throw const AppNameLocalizationException(
        'The pubspec.yaml file must contain a top-level mapping.',
      );
    }

    final Object? rawConfig = document[_configSectionName];
    if (rawConfig == null) {
      throw const AppNameLocalizationException(
        'The flutter_app_name_localization section is missing in the pubspec.yaml file.',
      );
    }
    if (rawConfig is! YamlMap) {
      throw const AppNameLocalizationException(
        'The flutter_app_name_localization section must be a mapping.',
      );
    }

    final String defaultName = _readRequiredString(
      rawConfig,
      'default',
      context: 'flutter_app_name_localization.default',
    );

    final Object? rawLocales = rawConfig['locales'];
    final Map<String, String> locales = <String, String>{};
    if (rawLocales != null) {
      if (rawLocales is! YamlList) {
        throw const AppNameLocalizationException(
          'flutter_app_name_localization.locales must be a list.',
        );
      }

      for (final Object? entry in rawLocales) {
        if (entry is! YamlMap) {
          throw const AppNameLocalizationException(
            'Each flutter_app_name_localization.locales entry must be a mapping.',
          );
        }

        final String locale = _readRequiredString(
          entry,
          'locale',
          context: 'flutter_app_name_localization.locales[].locale',
        );
        final String name = _readRequiredString(
          entry,
          'name',
          context: 'flutter_app_name_localization.locales[].name',
        );

        if (locales.containsKey(locale)) {
          throw AppNameLocalizationException(
            'Duplicate locale "$locale" found in flutter_app_name_localization.locales.',
          );
        }

        locales[locale] = name;
      }
    }

    return AppNameLocalizationConfig(
      defaultName: defaultName,
      locales: locales,
    );
  }

  static String _readRequiredString(
    YamlMap map,
    String key, {
    required String context,
  }) {
    final Object? value = map[key];
    if (value is! String || value.trim().isEmpty) {
      throw AppNameLocalizationException(
        '$context must be a non-empty string.',
      );
    }
    return value;
  }
}
