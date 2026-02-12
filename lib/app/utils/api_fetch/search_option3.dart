import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skkumap/app/model/search_option3_model.dart';
import 'package:skkumap/app/utils/constants.dart';

Future<SearchOption3Model> searchOption3(String queryString) async {
  String encodedQuery = Uri.encodeComponent(queryString);
  String url = '${ApiConfig.baseUrl}/search/option3/$encodedQuery';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return SearchOption3Model.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
