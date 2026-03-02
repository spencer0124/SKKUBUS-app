/// Environment-aware API configuration.
///
/// Uses `--dart-define-from-file` to inject BASE_URL and ENV at build time:
/// ```bash
/// flutter run --dart-define-from-file=env/staging.env   # prod API
/// flutter run --dart-define-from-file=env/dev-ios.env    # local server (iOS)
/// flutter run --dart-define-from-file=env/dev-android.env # local server (Android)
/// flutter build apk --dart-define-from-file=env/prod.env # release
/// ```
class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.skkuuniverse.com', // safe default = prod
  );

  static const _env = String.fromEnvironment('ENV', defaultValue: 'prod');

  static bool get isProduction => _env == 'prod';
}
