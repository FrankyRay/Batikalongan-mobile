import 'dart:convert';
import 'dart:io'; // For non-web platforms
import 'package:flutter/foundation.dart' show kIsWeb; // Detect platform
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/gallery_entry.dart';

class GalleryService {
  final String baseUrl;

  GalleryService(this.baseUrl);

  /// Fetch gallery entries with pagination
  Future<Map<String, dynamic>> fetchGalleryEntries(CookieRequest request, {int page = 1}) async {
    final url = Uri.parse('$baseUrl/gallery/json/?page=$page');

    try {
      final response = await request.get(url.toString());
      if (response['entries'] != null) {
        final entriesData = json.decode(response['entries']) as List;
        final entries = entriesData.map((entry) => GalleryEntry.fromJson(entry)).toList();
        return {
          'entries': entries,
          'hasNext': response['has_next'],
          'hasPrevious': response['has_previous'],
          'currentPage': response['current_page'],
          'numPages': response['num_pages'],
        };
      } else {
        throw Exception('Invalid response format: entries missing');
      }
    } catch (e) {
      print('Error fetching gallery entries: $e');
      rethrow;
    }
  }

  /// Create a new gallery entry
  Future<bool> createGalleryEntry(CookieRequest request, Map<String, String> data, File? image) async {
    final url = Uri.parse('$baseUrl/gallery/add/flutter/');

    try {
      final requestHttp = http.MultipartRequest('POST', url);
      data.forEach((key, value) {
        requestHttp.fields[key] = value;
      });

      if (image != null) {
        requestHttp.files.add(await http.MultipartFile.fromPath('foto', image.path));
      }

      final response = await requestHttp.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 201 && jsonResponse['message'] == 'Entri galeri berhasil dibuat') {
        return true;
      } else {
        print('Error adding entry: ${jsonResponse['message']}');
        return false;
      }
    } catch (e) {
      print('Error in createGalleryEntry: $e');
      return false;
    }
  }

  /// Edit an existing gallery entry
  Future<bool> editGalleryEntry(CookieRequest request, String id, Map<String, String> data, File? image) async {
    final url = Uri.parse('$baseUrl/gallery/edit/$id/flutter/');

    try {
      final requestHttp = http.MultipartRequest('POST', url);
      data.forEach((key, value) {
        requestHttp.fields[key] = value;
      });

      if (image != null) {
        requestHttp.files.add(await http.MultipartFile.fromPath('foto', image.path));
      }

      final response = await requestHttp.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200 && jsonResponse['message'] == 'Updated successfully') {
        return true;
      } else {
        print('Error editing entry: ${jsonResponse['message']}');
        return false;
      }
    } catch (e) {
      print('Error in editGalleryEntry: $e');
      return false;
    }
  }

  /// Delete a gallery entry
  Future<bool> deleteGalleryEntry(CookieRequest request, String id) async {
    final url = Uri.parse('$baseUrl/gallery/delete/$id/flutter/');

    try {
      final response = await request.post(url.toString(), {});
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['message'] == 'Deleted successfully') {
          return true;
        } else {
          print('Error deleting entry: ${jsonResponse['message']}');
          return false;
        }
      } else {
        print('Failed to delete entry with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in deleteGalleryEntry: $e');
      return false;
    }
  }
}
