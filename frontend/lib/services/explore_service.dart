import 'dart:convert';
import 'package:http/http.dart' as http;

class ExploreService {
  final String apiUrl = "http://10.0.2.2:8080/api/explore"; // TODO change after production

  Future<Map<String, dynamic>?> search(String query) async {
    try {
      final response = await http.get(Uri.parse("$apiUrl?query=$query"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to load search results: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching search results: $e");
      return null;
    }
  }
}
