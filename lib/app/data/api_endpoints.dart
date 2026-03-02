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
  static String busHsscLocation() => '/bus/hssc/v1/buslocation/';
  static String busJongroLocation(String line) =>
      '/bus/jongro/v1/buslocation/$line';
  static String busHsscStations() => '/bus/hssc/v1/busstation/';
  static String busJongroStations(String line) =>
      '/bus/jongro/v1/busstation/$line';

  // ── Campus shuttle (INJA/JAIN) ───────────────────
  static String campusSchedule(String prefix, String type) =>
      '/campus/v1/campus/${prefix}_$type';

  // ── Station ──────────────────────────────────────
  static String station(String stationId) => '/station/v1/$stationId';

  // ── UI (Server-Driven) ───────────────────────────
  static String homeBusList() => '/mobile/v1/mainpage/buslist';
  static String homeScroll() => '/mobile/v1/mainpage/scrollcomponent';

  // ── Search ───────────────────────────────────────
  // [query] is passed unencoded — Dio encodes path segments automatically.
  static String searchBuildings(String query) => '/search/option3/$query';
  static String searchDetail(String buildNo, String id) =>
      '/search/detail/$buildNo/$id';

  // ── Ads ──────────────────────────────────────────
  static String adPlacements() => '/ad/v1/placements';
  static String adEvents() => '/ad/v1/events';

  // ── App config (v2) ──────────────────────────────
  static String appConfig() => '/app/config';
}
