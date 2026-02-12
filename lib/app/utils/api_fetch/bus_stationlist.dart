import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skkumap/app/model/main_bus_stationlist.dart';
import 'package:skkumap/app/types/bus_type.dart';
import 'package:skkumap/app/utils/constants.dart';

Future<MainBusStationList> fetchMainBusStations(
    {required BusType busType}) async {
  String url;

  if (busType == BusType.jongro07Bus) {
    url = '${ApiConfig.baseUrl}/bus/jongro/v1/busstation/07';
  } else if (busType == BusType.jongro02Bus) {
    url = '${ApiConfig.baseUrl}/bus/jongro/v1/busstation/02';
  } else {
    url = '${ApiConfig.baseUrl}/bus/hssc/v1/busstation/';
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return MainBusStationList.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load bus stations data');
  }
}
