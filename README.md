# flutter_app_name_localization

`flutter_app_name_localization` is a Flutter plugin that simplifies the process of localizing your Android app's name. This plugin reads the app name configuration from your `pubspec.yaml` file and updates the Android manifest accordingly.

## Features

- Localize the app name for different languages
- Automatically update the Android manifest
- Easy configuration via `pubspec.yaml`

## Getting Started

### Installation

Add `flutter_app_name_localization` to your `pubspec.yaml` file under `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_app_name_localization: ^0.0.6
```

### Configuration

Configure your localized app names in the `pubspec.yaml` file under the `flutter_app_name_localization` section:

```yaml
flutter_app_name_localization:
  default: "MyApp"
  locales:
    - locale: "de"
      name: "MeineApp"
    - locale: "fr"
      name: "MonApp"
```

- `default`: The default app name.
- `locales`: A list of locales and their corresponding app names.

### Usage

1- After configuring your app names, run the following command to update the Android manifest:

```bash
dart run flutter_app_name_localization
```

This command will create values-de and values-fr directories in the `android/app/src/main/res` directory.

2- Update your App name in the `AndroidManifest.xml` file:

```xml
 android:label="@string/app_name"
```

### Example

Given the following configuration in `pubspec.yaml`:

```yaml
flutter_app_name_localization:
  default: "MyApp"
  locales:
    - locale: "de"
      name: "MeineApp"
    - locale: "fr"
      name: "MonApp"
```

Running `dart run flutter_app_name_localization` will create the following directories:

```bash
android/app/src/main/res/values-de
android/app/src/main/res/values-fr
```

The `strings.xml` file in the `values-de` directory will contain:

```xml
<resources>
    <string name="app_name">MeineApp</string>
</resources>
```

The `strings.xml` file in the `values-fr` directory will contain:

```xml
<resources>
    <string name="app_name">MonApp</string>
</resources>
```

!! Warning !!: You still need to update the `AndroidManifest.xml` file manually. Go to "Usage" section Step2 for more information.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

### Support

If you encounter any issues or have questions, feel free to open an issue on the [GitHub repository](https://github.com/BubiApps-LTD/flutter_app_name_localization).

### Contributors

- <a href="https://github.com/mahirozdin">
    <img src="https://avatars.githubusercontent.com/u/9491185?v=4" width="40" height="40" style="border-radius:50%;"/>
  </a> [Mahir Taha Ozdin](https://github.com/mahirozdin)
- <a href="https://github.com/maurovanetti">
    <img src="https://avatars.githubusercontent.com/u/402070?v=4" width="40" height="40" style="border-radius:50%;"/>
  </a> [Mauro Vanetti](https://github.com/maurovanetti)
