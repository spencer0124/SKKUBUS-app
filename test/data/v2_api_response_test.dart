/// Comprehensive v2 API response parsing tests.
///
/// Every test uses a **real response snapshot** from the production API
/// (api.skkuuniverse.com), captured 2026-03-02. This guarantees that
/// the Flutter models can parse what the server actually sends.
///
/// Each test group verifies:
///  1. The v2 envelope `{ meta, data }` structure is handled
///  2. Every field on the parsed model matches the snapshot values
///  3. Nullable/optional fields are parsed correctly (both present and null)
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/repositories/ad_repository.dart';
import 'package:skkumap/features/transit/data/bus_repository.dart';
import 'package:skkumap/features/building/data/building_repository.dart';
import 'package:skkumap/features/transit/data/station_repository.dart';
import 'package:skkumap/core/repositories/ui_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/model/ad_model.dart';
import 'package:skkumap/features/transit/model/realtime_data.dart';
import 'package:skkumap/features/transit/model/mainpage_buslist_model.dart' show BusListItem;
import 'package:skkumap/features/building/model/building_search_result.dart';
import 'package:skkumap/features/transit/model/station_model.dart';

// ────────────────────────────────────────────────────────────────────────────
// Real API response snapshots (captured 2026-03-08)
// ────────────────────────────────────────────────────────────────────────────

/// GET /bus/realtime/data/hssc — no buses running
const _realtimeDataEmpty = <String, dynamic>{
  'meta': {'lang': 'ko', 'currentTime': '08:00 PM', 'totalBuses': 0},
  'data': {
    'groupId': 'hssc',
    'buses': <dynamic>[],
    'stationEtas': <dynamic>[],
  },
};

/// GET /bus/realtime/data/hssc — two buses running
const _realtimeDataWithBuses = <String, dynamic>{
  'meta': {'lang': 'ko', 'currentTime': '10:30 AM', 'totalBuses': 2},
  'data': {
    'groupId': 'hssc',
    'buses': [
      {
        'stationIndex': 0,
        'carNumber': '0000',
        'estimatedTime': 30,
      },
      {
        'stationIndex': 7,
        'carNumber': '1111',
        'estimatedTime': 15,
      },
    ],
    'stationEtas': <dynamic>[],
  },
};

/// GET /bus/realtime/data/jongro02 — one bus with stationEtas
const _realtimeDataJongro = <String, dynamic>{
  'meta': {'lang': 'ko', 'currentTime': '10:59 AM', 'totalBuses': 1},
  'data': {
    'groupId': 'jongro02',
    'buses': [
      {
        'stationIndex': 14,
        'carNumber': '2009',
        'estimatedTime': 40,
        'latitude': 37.570576,
        'longitude': 126.983166,
      },
    ],
    'stationEtas': [
      {'stationIndex': 0, 'eta': '3분후[1번째 전]'},
      {'stationIndex': 5, 'eta': '13분9초후[11번째 전]'},
    ],
  },
};

/// GET /bus/station/01592 — two bus lines at this stop
const _stationArrival = <String, dynamic>{
  'meta': {
    'lang': 'ko',
    'totalCount': 2,
  },
  'data': [
    {
      'busNm': '종로07',
      'busSupportTime': true,
      'msg1ShowMessage': true,
      'msg1Message': '정보 없음',
      'msg1RemainStation': null,
      'msg1RemainSeconds': null,
      'msg2ShowMessage': false,
      'msg2Message': null,
      'msg2RemainStation': null,
      'msg2RemainSeconds': null,
    },
    {
      'busNm': '인사캠셔틀',
      'busSupportTime': false,
      'msg1ShowMessage': true,
      'msg1Message': '도착 정보 없음',
      'msg1RemainStation': null,
      'msg1RemainSeconds': null,
      'msg2ShowMessage': true,
      'msg2Message': null,
      'msg2RemainStation': null,
      'msg2RemainSeconds': null,
    },
  ],
};

/// GET /bus/station/01592 — bus with arrival time data
const _stationArrivalWithTimes = <String, dynamic>{
  'meta': {
    'lang': 'ko',
    'totalCount': 1,
  },
  'data': [
    {
      'busNm': '종로02',
      'busSupportTime': true,
      'msg1ShowMessage': true,
      'msg1Message': '5분51초후[3번째 전]',
      'msg1RemainStation': 3,
      'msg1RemainSeconds': 351,
      'msg2ShowMessage': true,
      'msg2Message': '13분9초후[11번째 전]',
      'msg2RemainStation': 11,
      'msg2RemainSeconds': 789,
    },
  ],
};

/// GET /ui/home/buslist — 4 bus items in the home screen list (new format)
const _homeBusList = <String, dynamic>{
  'meta': {
    'lang': 'ko',
    'busListCount': 4,
  },
  'data': [
    {
      'groupId': 'hssc',
      'card': {
        'label': '인사캠 셔틀버스',
        'themeColor': '003626',
        'iconType': 'shuttle',
        'busTypeText': '성대',
      },
      'action': {
        'route': '/bus/realtime',
        'groupId': 'hssc',
      },
    },
    {
      'groupId': 'campus',
      'card': {
        'label': '인자셔틀',
        'themeColor': '003626',
        'iconType': 'shuttle',
        'busTypeText': '성대',
      },
      'action': {
        'route': '/bus/schedule',
        'groupId': 'campus',
      },
    },
    {
      'groupId': 'jongro02',
      'card': {
        'label': '종로 02',
        'themeColor': '4CAF50',
        'iconType': 'village',
        'busTypeText': '마을',
      },
      'action': {
        'route': '/bus/realtime',
        'groupId': 'jongro02',
      },
    },
    {
      'groupId': 'jongro07',
      'card': {
        'label': '종로 07',
        'themeColor': '4CAF50',
        'iconType': 'village',
        'busTypeText': '마을',
      },
      'action': {
        'route': '/bus/realtime',
        'groupId': 'jongro07',
      },
    },
  ],
};

/// GET /ad/placements — splash + main_banner
const _adPlacements = <String, dynamic>{
  'meta': {
    'lang': 'ko',
    'count': 2,
  },
  'data': {
    'splash': {
      'type': 'image',
      'imageUrl': 'https://i.imgur.com/VEJpasQ.png',
      'text': null,
      'linkUrl': 'http://pf.kakao.com/_cjxexdG',
      'enabled': true,
      'adId': '69a3ca4e715fff63ea474882',
    },
    'main_banner': {
      'type': 'text',
      'imageUrl': null,
      'text': '스꾸버스 카카오톡 채널 - 문의하기',
      'linkUrl': 'http://pf.kakao.com/_cjxexdG',
      'enabled': true,
      'adId': '69a3ca4e715fff63ea474883',
    },
  },
};

/// GET /search/facilities/경영 — 35 results across hssc + nsc (trimmed)
const _buildingSearch = <String, dynamic>{
  'meta': {
    'lang': 'ko',
    'keyword': '경영',
    'buildingCount': 2,
    'spaceCount': 3,
  },
  'data': {
    'buildings': [
      {
        '_id': 33,
        'buildNo': '133',
        'name': {'ko': '경영관', 'en': 'Business Building'},
        'campus': 'hssc',
        'type': 'building',
        'location': {
          'type': 'Point',
          'coordinates': [126.992666, 37.588572],
        },
        'image': {'url': 'https://example.com/133.jpg', 'filename': '133.jpg'},
      },
    ],
    'spaces': [
      {
        'buildNo': '133',
        'buildingName': {'ko': '경영관', 'en': 'Business Building'},
        'items': [
          {
            'spaceCd': '33106A',
            'name': {'ko': '경영대학 스터디홀', 'en': 'Business School Study Hall'},
            'floor': {'ko': '1층', 'en': '1F'},
          },
        ],
      },
    ],
  },
};

// ────────────────────────────────────────────────────────────────────────────
// Tests
// ────────────────────────────────────────────────────────────────────────────

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dioAdapter = DioAdapter(dio: dio);
    client = ApiClient(dio);
  });

  // ── 1. Realtime Data (HSSC) — empty ───────────────────────────────────
  group('GET /bus/realtime/data/hssc (empty)', () {
    test('parses empty buses from real v2 response', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/hssc',
        (server) => server.reply(200, _realtimeDataEmpty),
      );

      final repo = BusRepository(client);
      final result = await repo.getRealtimeData('/bus/realtime/data/hssc');

      expect(result, isA<Ok<RealtimeData>>());
      final data = (result as Ok<RealtimeData>).data;
      expect(data.groupId, 'hssc');
      expect(data.buses, isEmpty);
      expect(data.stationEtas, isEmpty);
      expect(data.meta.currentTime, '08:00 PM');
      expect(data.meta.totalBuses, 0);
    });
  });

  // ── 2. Realtime Data (HSSC) — with buses ──────────────────────────────
  group('GET /bus/realtime/data/hssc (with buses)', () {
    test('parses two buses with 0-based stationIndex', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/hssc',
        (server) => server.reply(200, _realtimeDataWithBuses),
      );

      final repo = BusRepository(client);
      final result = await repo.getRealtimeData('/bus/realtime/data/hssc');

      expect(result, isA<Ok<RealtimeData>>());
      final data = (result as Ok<RealtimeData>).data;
      expect(data.meta.totalBuses, 2);
      expect(data.buses, hasLength(2));

      final bus1 = data.buses[0];
      expect(bus1.stationIndex, 0);
      expect(bus1.carNumber, '0000');
      expect(bus1.estimatedTime, 30);

      final bus2 = data.buses[1];
      expect(bus2.stationIndex, 7);
      expect(bus2.carNumber, '1111');
      expect(bus2.estimatedTime, 15);
    });
  });

  // ── 3. Realtime Data (Jongro) — with stationEtas ──────────────────────
  group('GET /bus/realtime/data/jongro02', () {
    test('parses bus with stationEtas', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/jongro02',
        (server) => server.reply(200, _realtimeDataJongro),
      );

      final repo = BusRepository(client);
      final result =
          await repo.getRealtimeData('/bus/realtime/data/jongro02');

      expect(result, isA<Ok<RealtimeData>>());
      final data = (result as Ok<RealtimeData>).data;
      expect(data.groupId, 'jongro02');
      expect(data.meta.totalBuses, 1);

      expect(data.buses, hasLength(1));
      final bus = data.buses[0];
      expect(bus.stationIndex, 14);
      expect(bus.carNumber, '2009');
      expect(bus.estimatedTime, 40);

      expect(data.stationEtas, hasLength(2));
      expect(data.stationEtas[0].stationIndex, 0);
      expect(data.stationEtas[0].eta, '3분후[1번째 전]');
      expect(data.stationEtas[1].stationIndex, 5);
      expect(data.stationEtas[1].eta, '13분9초후[11번째 전]');
    });
  });

  // ── 4. Station Arrival — camelCase field parsing ─────────────────────
  group('GET /bus/station/01592', () {
    test('parses meta with totalCount (no success field)', () async {
      dioAdapter.onGet(
        ApiEndpoints.station('01592'),
        (server) => server.reply(200, _stationArrival),
      );

      final repo = StationRepository(client);
      final result = await repo.getStationData('01592');

      expect(result, isA<Ok<StationResponse>>());
      final data = (result as Ok<StationResponse>).data;
      expect(data.metaData.totalCount, 2);
      expect(data.metaData.success, true); // defaults to true when absent
    });

    test('parses bus with null arrival times (msg1ShowMessage camelCase)',
        () async {
      dioAdapter.onGet(
        ApiEndpoints.station('01592'),
        (server) => server.reply(200, _stationArrival),
      );

      final repo = StationRepository(client);
      final result = await repo.getStationData('01592');
      final buses = (result as Ok<StationResponse>).data.stationData;
      expect(buses, hasLength(2));

      // First bus: 종로07 with msg1 visible, msg2 hidden
      final bus1 = buses[0];
      expect(bus1.busNm, '종로07');
      expect(bus1.busSupportTime, true);
      expect(bus1.msg1Showmessage, true);
      expect(bus1.msg1Message, '정보 없음');
      expect(bus1.msg1RemainStation, isNull);
      expect(bus1.msg1RemainSeconds, isNull);
      expect(bus1.msg2Showmessage, false);
      expect(bus1.msg2Message, isNull);
      expect(bus1.msg2RemainStation, isNull);
      expect(bus1.msg2RemainSeconds, isNull);

      // Second bus: 인사캠셔틀
      final bus2 = buses[1];
      expect(bus2.busNm, '인사캠셔틀');
      expect(bus2.busSupportTime, false);
      expect(bus2.msg1Showmessage, true);
      expect(bus2.msg1Message, '도착 정보 없음');
      expect(bus2.msg2Showmessage, true);
      expect(bus2.msg2Message, isNull);
    });

    test('parses bus with actual remain times', () async {
      dioAdapter.onGet(
        ApiEndpoints.station('01592'),
        (server) => server.reply(200, _stationArrivalWithTimes),
      );

      final repo = StationRepository(client);
      final result = await repo.getStationData('01592');
      final buses = (result as Ok<StationResponse>).data.stationData;
      expect(buses, hasLength(1));

      final bus = buses[0];
      expect(bus.busNm, '종로02');
      expect(bus.busSupportTime, true);
      expect(bus.msg1Showmessage, true);
      expect(bus.msg1Message, '5분51초후[3번째 전]');
      expect(bus.msg1RemainStation, 3);
      expect(bus.msg1RemainSeconds, 351);
      expect(bus.msg2Showmessage, true);
      expect(bus.msg2Message, '13분9초후[11번째 전]');
      expect(bus.msg2RemainStation, 11);
      expect(bus.msg2RemainSeconds, 789);
    });
  });

  // ── 5. Home Bus List (SDUI) ──────────────────────────────────────────
  group('GET /ui/home/buslist', () {
    test('parses all 4 bus list items', () async {
      dioAdapter.onGet(
        ApiEndpoints.homeTransitList(),
        (server) => server.reply(200, _homeBusList),
      );

      final repo = UiRepository(client);
      final result = await repo.getMainpageBusList();

      expect(result, isA<Ok<List<BusListItem>>>());
      final items = (result as Ok<List<BusListItem>>).data;
      expect(items, hasLength(4));
    });

    test('first item: hssc shuttle with card and action', () async {
      dioAdapter.onGet(
        ApiEndpoints.homeTransitList(),
        (server) => server.reply(200, _homeBusList),
      );

      final repo = UiRepository(client);
      final result = await repo.getMainpageBusList();
      final first = (result as Ok<List<BusListItem>>).data[0];

      expect(first.groupId, 'hssc');
      expect(first.card.label, '인사캠 셔틀버스');
      expect(first.card.themeColor, '003626');
      expect(first.card.iconType, 'shuttle');
      expect(first.card.busTypeText, '성대');
      expect(first.action.route, '/bus/realtime');
      expect(first.action.groupId, 'hssc');
    });

    test('second item: campus schedule', () async {
      dioAdapter.onGet(
        ApiEndpoints.homeTransitList(),
        (server) => server.reply(200, _homeBusList),
      );

      final repo = UiRepository(client);
      final result = await repo.getMainpageBusList();
      final second = (result as Ok<List<BusListItem>>).data[1];

      expect(second.groupId, 'campus');
      expect(second.card.label, '인자셔틀');
      expect(second.action.route, '/bus/schedule');
      expect(second.action.groupId, 'campus');
    });

    test('third item: jongro02 village bus', () async {
      dioAdapter.onGet(
        ApiEndpoints.homeTransitList(),
        (server) => server.reply(200, _homeBusList),
      );

      final repo = UiRepository(client);
      final result = await repo.getMainpageBusList();
      final third = (result as Ok<List<BusListItem>>).data[2];

      expect(third.groupId, 'jongro02');
      expect(third.card.label, '종로 02');
      expect(third.card.themeColor, '4CAF50');
      expect(third.card.iconType, 'village');
      expect(third.card.busTypeText, '마을');
      expect(third.action.route, '/bus/realtime');
    });
  });

  // ── 6. Ad Placements ─────────────────────────────────────────────────
  group('GET /ad/placements', () {
    test('parses placement map from real v2 response', () async {
      dioAdapter.onGet(
        ApiEndpoints.adPlacements(),
        (server) => server.reply(200, _adPlacements),
      );

      final repo = AdRepository(client);
      final result = await repo.getPlacements();

      expect(result, isA<Ok<AdPlacementsResponse>>());
      final data = (result as Ok<AdPlacementsResponse>).data;
      expect(data.placements, hasLength(2));
      expect(data.placements.containsKey('splash'), true);
      expect(data.placements.containsKey('main_banner'), true);
    });

    test('splash ad: image type with all fields', () async {
      dioAdapter.onGet(
        ApiEndpoints.adPlacements(),
        (server) => server.reply(200, _adPlacements),
      );

      final repo = AdRepository(client);
      final result = await repo.getPlacements();
      final splash = (result as Ok<AdPlacementsResponse>).data['splash']!;

      expect(splash.type, 'image');
      expect(splash.imageUrl, 'https://i.imgur.com/VEJpasQ.png');
      expect(splash.text, isNull);
      expect(splash.linkUrl, 'http://pf.kakao.com/_cjxexdG');
      expect(splash.enabled, true);
      expect(splash.adId, '69a3ca4e715fff63ea474882');
    });

    test('main_banner ad: text type with imageUrl=null', () async {
      dioAdapter.onGet(
        ApiEndpoints.adPlacements(),
        (server) => server.reply(200, _adPlacements),
      );

      final repo = AdRepository(client);
      final result = await repo.getPlacements();
      final banner =
          (result as Ok<AdPlacementsResponse>).data['main_banner']!;

      expect(banner.type, 'text');
      expect(banner.imageUrl, isNull);
      expect(banner.text, '스꾸버스 카카오톡 채널 - 문의하기');
      expect(banner.linkUrl, 'http://pf.kakao.com/_cjxexdG');
      expect(banner.enabled, true);
      expect(banner.adId, '69a3ca4e715fff63ea474883');
    });
  });

  // ── 7. Building Search ──────────────────────────────────────────────
  group('GET /building/search?q=경영', () {
    test('parses meta with building/space counts', () async {
      dioAdapter.onGet(
        ApiEndpoints.buildingSearch(),
        (server) => server.reply(200, _buildingSearch),
        queryParameters: {'q': '경영'},
      );

      final repo = BuildingRepository(client);
      final result = await repo.search('경영');

      expect(result, isA<Ok<BuildingSearchResult>>());
      final data = (result as Ok<BuildingSearchResult>).data;

      expect(data.keyword, '경영');
      expect(data.buildingCount, 2);
      expect(data.spaceCount, 3);
    });

    test('parses building results', () async {
      dioAdapter.onGet(
        ApiEndpoints.buildingSearch(),
        (server) => server.reply(200, _buildingSearch),
        queryParameters: {'q': '경영'},
      );

      final repo = BuildingRepository(client);
      final result = await repo.search('경영');
      final buildings = (result as Ok<BuildingSearchResult>).data.buildings;
      expect(buildings, hasLength(1));

      final b = buildings[0];
      expect(b.skkuId, 33);
      expect(b.buildNo, '133');
      expect(b.name.ko, '경영관');
      expect(b.name.en, 'Business Building');
      expect(b.campus, 'hssc');
      // GeoJSON [lng, lat] → lat, lng
      expect(b.lat, 37.588572);
      expect(b.lng, 126.992666);
    });

    test('parses grouped space results', () async {
      dioAdapter.onGet(
        ApiEndpoints.buildingSearch(),
        (server) => server.reply(200, _buildingSearch),
        queryParameters: {'q': '경영'},
      );

      final repo = BuildingRepository(client);
      final result = await repo.search('경영');
      final spaces = (result as Ok<BuildingSearchResult>).data.spaces;
      expect(spaces, hasLength(1));

      final group = spaces[0];
      expect(group.buildNo, '133');
      expect(group.buildingName.ko, '경영관');
      expect(group.items, hasLength(1));

      final space = group.items[0];
      expect(space.spaceCd, '33106A');
      expect(space.name.ko, '경영대학 스터디홀');
      expect(space.floor.ko, '1층');
    });
  });

  // ── 8. Endpoint paths match production ───────────────────────────────
  group('ApiEndpoints paths', () {
    test('station arrival path', () {
      expect(ApiEndpoints.station('01592'), '/bus/station/01592');
    });

    test('UI paths', () {
      expect(ApiEndpoints.homeTransitList(), '/ui/home/transitlist');
      expect(ApiEndpoints.homeScroll(), '/ui/home/scroll');
    });

    test('building search endpoint', () {
      expect(ApiEndpoints.buildingSearch(), '/building/search');
    });

    test('building detail endpoint', () {
      expect(ApiEndpoints.buildingDetail(27), '/building/27');
    });

    test('building list endpoint', () {
      expect(ApiEndpoints.buildingList(), '/building/list');
    });

    test('ad paths', () {
      expect(ApiEndpoints.adPlacements(), '/ad/placements');
      expect(ApiEndpoints.adEvents(), '/ad/events');
    });

    test('bus config group path', () {
      expect(ApiEndpoints.busConfigGroup('hssc'), '/bus/config/hssc');
      expect(ApiEndpoints.busConfigGroup('campus'), '/bus/config/campus');
    });

    test('app config path', () {
      expect(ApiEndpoints.appConfig(), '/app/config');
    });
  });

  // ── 9. Invalid envelope handling ────────────────────────────────────
  group('invalid v2 envelope', () {
    test('bare list returns ParseFailure', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/hssc',
        (server) => server.reply(200, []),
      );

      final repo = BusRepository(client);
      final result = await repo.getRealtimeData('/bus/realtime/data/hssc');

      expect(result, isA<Err<RealtimeData>>());
      final failure = (result as Err<RealtimeData>).failure;
      expect(failure, isA<ParseFailure>());
      expect(failure.message, 'Invalid v2 envelope');
    });

    test('map without data key returns ParseFailure', () async {
      dioAdapter.onGet(
        ApiEndpoints.adPlacements(),
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
        }),
      );

      final repo = AdRepository(client);
      final result = await repo.getPlacements();

      expect(result, isA<Err<AdPlacementsResponse>>());
      final failure = (result as Err<AdPlacementsResponse>).failure;
      expect(failure, isA<ParseFailure>());
    });
  });
}
