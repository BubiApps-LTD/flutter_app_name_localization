class AppNameLocalizationException implements Exception {
  const AppNameLocalizationException(this.message);

  final String message;

  @override
  String toString() => message;
}
