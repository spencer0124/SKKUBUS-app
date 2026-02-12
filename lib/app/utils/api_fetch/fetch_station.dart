import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skkumap/app/model/station_model.dart';
import 'package:skkumap/app/utils/constants.dart';

Future<StationResponse> fetchStationData(String stationId) async {
  var url = '${ApiConfig.baseUrl}/station/v1/$stationId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return StationResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load station data');
  }
}
