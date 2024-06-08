import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String url = "https://onsr.nat.tn/onsr/dataxml/xmltojsonfile.php?type=heure2024";

  Future<Map<String, dynamic>> fetchDataFromNewAPI() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
