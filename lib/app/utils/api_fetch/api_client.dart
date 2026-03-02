/// Legacy API client — replaced by Dio-based ApiClient in `lib/app/data/`.
///
/// This file is kept only so existing `import 'api_client.dart'` statements
/// don't break during the transition. The global `apiClient` is no longer
/// used — `main.dart` calls the DI-registered ApiClient directly.
///
/// TODO: Remove this file once all imports are cleaned up.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skkumap/app/utils/app_logger.dart';

class _LegacyApiClient {
  /// Ensure anonymous sign-in. Kept for backward compat — main.dart now
  /// calls the DI-registered ApiClient.ensureAuth() instead.
  Future<void> ensureAuth() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
      logger.i('[auth] Anonymous sign-in complete: ${auth.currentUser?.uid}');
    }
  }
}

final apiClient = _LegacyApiClient();
