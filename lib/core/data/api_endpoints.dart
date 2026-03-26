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

  // ── UI (Server-Driven) ───────────────────────────
  static String homeTransitList() => '/ui/home/transitlist';
  static String homeScroll() => '/ui/home/scroll';
  static String homeCampus() => '/ui/home/campus';

  // ── Building ────────────────────────────────────
  static String buildingList() => '/building/list';
  static String buildingSearch() => '/building/search';
  static String buildingDetail(int skkuId) => '/building/$skkuId';

  // ── Ads ──────────────────────────────────────────
  static String adPlacements() => '/ad/placements';
  static String adEvents() => '/ad/events';

  // ── Bus config ────────────────────────────────
  static String busConfig() => '/bus/config';
  static String busConfigGroup(String groupId) => '/bus/config/$groupId';

  // ── Map ────────────────────────────────────────
  static String mapConfig() => '/map/config';
  static String aroundPlace() => '/map/v1/getaroundplacedata';

  // ── App config ─────────────────────────────────
  static String appConfig() => '/app/config';
}
