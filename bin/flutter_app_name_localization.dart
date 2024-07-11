import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:xml/xml.dart';

void main(List<String> arguments) {
  final parser = ArgParser()..addOption('config', abbr: 'c', help: 'Path to the pubspec.yaml file');

  final argResults = parser.parse(arguments);

  if (argResults['config'] == null) {
    print('Please provide the path to the pubspec.yaml file using --config or -c.');
    return;
  }

  final configPath = argResults['config'];
  final pubspecFile = File(configPath);

  if (!pubspecFile.existsSync()) {
    print('The provided pubspec.yaml file does not exist.');
    return;
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecYaml = loadYaml(pubspecContent);

  if (pubspecYaml['flutter_app_name_localization'] == null) {
    print('The flutter_app_name_localization section is missing in the pubspec.yaml file.');
    return;
  }

  final config = pubspecYaml['flutter_app_name_localization'];
  final defaultName = config['default'];
  final locales = config['locales'];

  if (defaultName == null || locales == null) {
    print('The default name or locales are missing in the flutter_app_name_localization section.');
    return;
  }

  final androidDir = Directory('android/app/src/main/res');
  if (!androidDir.existsSync()) {
    print('The android directory does not exist.');
    return;
  }

  updateStringsXml(androidDir, 'values', 'app_name', defaultName);

  for (var locale in locales) {
    final localeCode = locale['locale'];
    final localeName = locale['name'];

    if (localeCode == null || localeName == null) {
      print('Invalid locale configuration.');
      continue;
    }

    updateStringsXml(androidDir, 'values-$localeCode', 'app_name', localeName);
  }

  print('App name localization completed successfully.');
}

void updateStringsXml(Directory resDir, String dirName, String key, String value) {
  final dir = Directory(path.join(resDir.path, dirName));
  if (!dir.existsSync()) {
    dir.createSync();
  }

  final file = File(path.join(dir.path, 'strings.xml'));
  XmlDocument xmlDocument;

  if (file.existsSync()) {
    final content = file.readAsStringSync();
    xmlDocument = XmlDocument.parse(content);
  } else {
    xmlDocument = XmlDocument.parse('<resources></resources>');
  }

  final resourcesElement = xmlDocument.getElement('resources');
  final existingElement = resourcesElement?.findAllElements('string').firstWhere(
        (element) => element.getAttribute('name') == key,
        orElse: () => null as XmlElement,
      );

  if (existingElement != null) {
    existingElement.innerText = value;
  } else {
    final builder = XmlBuilder();
    builder.element('string', nest: () {
      builder.attribute('name', key);
      builder.text(value);
    });
    resourcesElement?.children.add(builder.buildFragment());
  }

  file.writeAsStringSync(xmlDocument.toXmlString(pretty: true, indent: '  '));
}
