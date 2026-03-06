import 'package:flutter_app_name_localization/flutter_app_name_localization.dart';

void main() {
  final AppNameLocalizationResult result = AppNameLocalizer.localize(
    pubspecPath: 'pubspec.yaml',
  );

  for (final String file in result.updatedFiles) {
    print(file);
  }
}
