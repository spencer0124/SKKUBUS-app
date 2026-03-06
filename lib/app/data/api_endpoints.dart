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
  static String busHsscLocation() => '/bus/hssc/location';
  static String busJongroLocation(String line) => '/bus/jongro/location/$line';
  static String busHsscStations() => '/bus/hssc/stations';
  static String busJongroStations(String line) => '/bus/jongro/stations/$line';

  // ── Campus shuttle (INJA/JAIN) ───────────────────
  static String campusSchedule(String prefix, String type) =>
      '/bus/campus/${prefix}_$type';
  static String campusEta() => '/bus/campus/eta';

  // ── Station ──────────────────────────────────────
  static String station(String stationId) => '/bus/station/$stationId';

  // ── UI (Server-Driven) ───────────────────────────
  static String homeBusList() => '/ui/home/buslist';
  static String homeScroll() => '/ui/home/scroll';

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
  static String busConfigVersion() => '/bus/config/version';

  // ── App config ─────────────────────────────────
  static String appConfig() => '/app/config';
}
