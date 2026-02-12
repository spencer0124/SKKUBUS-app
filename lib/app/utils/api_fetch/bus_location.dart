import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skkumap/app/model/main_bus_location.dart';
import 'package:skkumap/app/types/bus_type.dart';
import 'package:skkumap/app/utils/constants.dart';

Future<List<MainBusLocation>> fetchMainBusLocation(
    {required BusType busType}) async {
  String url;

  if (busType == BusType.jongro07Bus) {
    url = '${ApiConfig.baseUrl}/bus/jongro/v1/buslocation/07';
  } else if (busType == BusType.jongro02Bus) {
    url = '${ApiConfig.baseUrl}/bus/jongro/v1/buslocation/02';
  } else {
    url = '${ApiConfig.baseUrl}/bus/hssc/v1/buslocation/';
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    return List<MainBusLocation>.from(
        l.map((model) => MainBusLocation.fromJson(model)));
  } else {
    throw Exception('Failed to fetch MainBusLocation');
  }
}
