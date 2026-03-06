import 'dart:io';

import 'package:args/args.dart';

import 'app_name_localization_exception.dart';
import 'app_name_localizer.dart';

typedef CliWriter = void Function(String message);

int runCli(
  List<String> arguments, {
  CliWriter stdoutWriter = _writeStdout,
  CliWriter stderrWriter = _writeStderr,
}) {
  final ArgParser parser = ArgParser()
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Path to the Flutter project pubspec.yaml file.',
      valueHelp: 'path',
    );

  final ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } on FormatException catch (error) {
    stderrWriter('Error: ${error.message}');
    stderrWriter(parser.usage);
    return 1;
  }

  final String configPath = (argResults['config'] as String?) ?? 'pubspec.yaml';

  try {
    final result = AppNameLocalizer.localize(pubspecPath: configPath);
    for (final String warning in result.warnings) {
      stderrWriter('Warning: $warning');
    }
    stdoutWriter(
      'App name localization completed successfully. '
      'Updated ${result.updatedFiles.length} file(s).',
    );
    return 0;
  } on AppNameLocalizationException catch (error) {
    stderrWriter('Error: $error');
    return 1;
  }
}

void _writeStdout(String message) => stdout.writeln(message);

void _writeStderr(String message) => stderr.writeln(message);
