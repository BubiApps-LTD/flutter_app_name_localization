# flutter_app_name_localization

`flutter_app_name_localization` is a Flutter plugin that simplifies the process of localizing your Android app's name. This plugin reads the app name configuration from your `pubspec.yaml` file and updates the Android manifest accordingly.

## Features

- Localize the app name for different languages
- Automatically update the Android manifest
- Easy configuration via `pubspec.yaml`

## Getting Started

### Installation

Add `flutter_app_name_localization` to your `pubspec.yaml` file under `dev_dependencies`:

\```yaml
dev_dependencies:
  flutter_app_name_localization: ^0.0.1
\```

### Configuration

Configure your localized app names in the `pubspec.yaml` file under the `flutter_app_name_localization` section:

\```yaml
flutter_app_name_localization:
  default: "MyApp"
  locales:
    - locale: "de"
      name: "MeineApp"
    - locale: "fr"
      name: "MonApp"
\```

- `default`: The default app name.
- `locales`: A list of locales and their corresponding app names.

### Usage

After configuring your app names, run the following command to update the Android manifest:

\```bash
flutter pub run flutter_app_name_localization
\```

This command will update the `android:label` attribute in your Android manifest to reflect the localized app names.

### Example

Given the following configuration in `pubspec.yaml`:

\```yaml
flutter_app_name_localization:
  default: "MyApp"
  locales:
    - locale: "de"
      name: "MeineApp"
    - locale: "fr"
      name: "MonApp"
\```

Running `flutter pub run flutter_app_name_localization` will update your `AndroidManifest.xml` to use `MeineApp` for German (de) users, `MonApp` for French (fr) users, and `MyApp` for all other users.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

### Support

If you encounter any issues or have questions, feel free to open an issue on the [GitHub repository](https://example.com).

### Maintainers

- [Your Name](https://github.com/your-github-username)

## Acknowledgments

- Inspired by the need to simplify localization for Flutter apps.
