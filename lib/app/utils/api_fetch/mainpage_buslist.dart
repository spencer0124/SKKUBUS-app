import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skkumap/app/model/mainpage_buslist_model.dart';
import 'package:skkumap/app/utils/constants.dart';

Future<MainPageBusListResponse> fetchMainpageBusList() async {
  final url = '${ApiConfig.baseUrl}/mobile/v1/mainpage/buslist';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return MainPageBusListResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load mainpage buslist data');
  }
}
