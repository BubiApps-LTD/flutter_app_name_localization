import 'app_name_localization_config.dart';

/// The result of updating localized Android app names for a Flutter project.
class AppNameLocalizationResult {
  AppNameLocalizationResult({
    required this.pubspecPath,
    required this.projectDirectory,
    required this.config,
    required List<String> updatedFiles,
    required List<String> warnings,
  })  : updatedFiles = List.unmodifiable(updatedFiles),
        warnings = List.unmodifiable(warnings);

  /// Absolute path to the parsed `pubspec.yaml`.
  final String pubspecPath;

  /// Absolute path to the Flutter project directory.
  final String projectDirectory;

  /// The parsed localization configuration.
  final AppNameLocalizationConfig config;

  /// Absolute paths to the `strings.xml` files that were updated.
  final List<String> updatedFiles;

  /// Non-fatal warnings discovered while localizing.
  final List<String> warnings;
}
