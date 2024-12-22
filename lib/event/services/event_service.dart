import 'dart:convert';
import 'package:batikalongan_mobile/event/models/event_entry.dart';
import 'package:http/http.dart' as http;
// import 'dart:html';

import 'package:pbp_django_auth/pbp_django_auth.dart'; // Untuk `File` di web.
// import '../models/gallery_entry.dart';

class EventService {
  final String baseUrl;

  EventService(this.baseUrl);

  Future<List<EventEntry>> fetchEventEntry() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/event/json/'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load event entries with status code: ${response.statusCode}');
      }

      final List data = json.decode(response.body);
      print(data);

      return data.map((entry) => EventEntry.fromJson(entry)).toList();
    } catch (e) {
      print('Error fetching event entries: $e');
      rethrow;
    }
  }
}
