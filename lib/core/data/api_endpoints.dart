/// Centralized API path definitions.
///
/// Every server endpoint used by the app is listed here.
/// For the v2 migration, change paths in this one file — repositories
/// and controllers remain untouched.
///
/// **URI encoding**: Paths are returned *unencoded*. Dio handles percent-encoding
/// of path segments automatically, so pre-encoding here would cause double-encoding
/// (e.g. Korean search queries turning into `%25EC%25...`).
class ApiEndpoints {
  ApiEndpoints._();

  // ── Bus ──────────────────────────────────────────

  // ── Campus shuttle ─────────────────────────────────
  static String campusEta() => '/bus/campus/eta';

  // ── Station ──────────────────────────────────────
  static String station(String stationId) => '/bus/station/$stationId';

  // ── UI (Server-Driven) ───────────────────────────
  static String homeBusList() => '/ui/home/buslist';
  static String homeScroll() => '/ui/home/scroll';
  static String homeCampus() => '/ui/home/campus';

  // ── Search ───────────────────────────────────────
  // [query] is passed unencoded — Dio encodes path segments automatically.
  static String searchBuildings(String query) => '/search/facilities/$query';
  static String searchDetail(String buildNo, String id) =>
      '/search/detail/$buildNo/$id';

  // ── Ads ──────────────────────────────────────────
  static String adPlacements() => '/ad/placements';
  static String adEvents() => '/ad/events';

  // ── Bus config ────────────────────────────────
  static String busConfig() => '/bus/config';
  static String busConfigGroup(String groupId) => '/bus/config/$groupId';

  // ── Map config ──────────────────────────────────
  static String mapConfig() => '/map/config';

  // ── App config ─────────────────────────────────
  static String appConfig() => '/app/config';
}
