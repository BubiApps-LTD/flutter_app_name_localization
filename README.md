# flutter_app_name_localization

`flutter_app_name_localization` is a build-time CLI for localizing the Android app name in Flutter projects. It reads app-name settings from your Flutter app's `pubspec.yaml` and writes the matching `android/app/src/main/res/values*/strings.xml` files.

This package does not register a runtime Flutter plugin.

## Install

Add the package to the Flutter app that needs localized app names:

```yaml
dev_dependencies:
  flutter_app_name_localization: ^0.1.0
```

## Configure

Add a `flutter_app_name_localization` section to the Flutter app's `pubspec.yaml`:

```yaml
flutter_app_name_localization:
  default: "My App"
  locales:
    - locale: "tr"
      name: "Uygulamam"
    - locale: "de"
      name: "Meine App"
```

- `default` is required.
- `locales` is optional.
- Locale values are written directly into Android resource qualifiers such as `values-tr` or `values-tr-rTR`.

## Android Manifest

Set the application label to `@string/app_name` in `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="@string/app_name"
    ...>
```

The CLI validates this and prints a warning to `stderr` if the manifest still uses a hard-coded label.

## Usage

Run the tool from the Flutter app root:

```bash
dart run flutter_app_name_localization
```

Or point it at a specific `pubspec.yaml`:

```bash
dart run flutter_app_name_localization --config path/to/pubspec.yaml
```

## Library API

```dart
import 'package:flutter_app_name_localization/flutter_app_name_localization.dart';

void main() {
  final result = AppNameLocalizer.localize(pubspecPath: 'pubspec.yaml');
  for (final file in result.updatedFiles) {
    print(file);
  }
}
```

## Migration From 0.0.6

- Runtime Flutter plugin registration has been removed.
- The package is now a normal Dart package with a typed API and CLI.
- Release builds no longer generate Android plugin registration for this package.
- The old MethodChannel-based example app and runtime API are gone.

## Development

```bash
dart format .
dart analyze
dart test
dart pub publish --dry-run
```
