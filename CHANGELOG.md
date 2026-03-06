## 0.1.0

- Rebuilt the package as a CLI-first Dart package instead of a runtime Flutter plugin.
- Removed Android plugin registration metadata and native plugin scaffolding to prevent release-build registration failures.
- Added a typed localization API with better config validation, manifest checks, and path handling.
- Kept the existing `flutter_app_name_localization` YAML section and `dart run flutter_app_name_localization` workflow.
- Replaced the Flutter example app with a lightweight Dart example and fixture-driven tests.

## 0.0.4

- Plugin fix.
