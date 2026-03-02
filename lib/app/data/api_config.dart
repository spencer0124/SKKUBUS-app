/// Environment-aware API configuration.
///
/// Mirrors the server's `lib/config.js` pattern:
/// - **dev**: local/dev server (like server's `npm run dev`)
/// - **staging**: prod API URL for pre-release testing (like `npm run dev:prod-api`)
/// - **prod**: production domain via Cloudflare
///
/// Set via `--dart-define=ENV=dev|staging|prod` at build time:
/// ```bash
/// flutter run --dart-define=ENV=dev          # default
/// flutter run --dart-define=ENV=staging      # test against prod API
/// flutter build apk --dart-define=ENV=prod   # release
/// ```
enum Environment { dev, staging, prod }

class ApiConfig {
  static const _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static Environment get environment => switch (_env) {
        'prod' => Environment.prod,
        'staging' => Environment.staging,
        _ => Environment.dev,
      };

  /// Base URL for all API requests.
  /// staging and prod share the same production URL — the distinction is in
  /// app-level behavior (logging verbosity, debug features), not the server.
  static String get baseUrl => switch (environment) {
        Environment.prod => 'https://api.skkuuniverse.com',
        Environment.staging => 'https://api.skkuuniverse.com',
        Environment.dev => 'http://43.200.90.214:3000',
      };

  static bool get isProduction => environment == Environment.prod;
}
