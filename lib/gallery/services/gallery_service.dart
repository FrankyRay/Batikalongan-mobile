import 'dart:convert';
import 'dart:html'; // For web platform.
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/gallery_entry.dart';

class GalleryService {
  final String baseUrl;

  GalleryService(this.baseUrl);

  Future<bool> createGalleryEntry(Map<String, String> data, File image) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/gallery/add/ajax/'));

  /// Fetch gallery entries with pagination
  Future<Map<String, dynamic>> fetchGalleryEntries(CookieRequest request, {int page = 1}) async {
    final url = '$baseUrl/gallery/json/?page=$page'; // Use String instead of Uri

    try {
      final response = await request.get(url);

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

  /// Add new gallery entry
  Future<bool> createGalleryEntry(CookieRequest request, Map<String, String> data, File image) async {
    final url = '$baseUrl/gallery/add/flutter/';
    final formData = FormData();

    // Add fields to FormData
    data.forEach((key, value) {
      formData.append(key, value);
    });

    // Add file
    formData.appendBlob('foto', image);

    try {

      final xhr = HttpRequest();
      xhr.open('POST', url);
      // xhr.setRequestHeader('X-CSRFToken', request.cookies['csrftoken'] ?? ''); // Pass CSRF token
      xhr.setRequestHeader('Authorization', 'Bearer ${request.cookies['auth_token']}'); // Optional: Use if needed
      xhr.withCredentials = true; // Ensures cookies are sent with the request

      xhr.send(formData);

      await xhr.onLoadEnd.first;

      if (xhr.status == 201) {
        return true;
      } else {

        print('Error adding entry: ${xhr.responseText}');
        return false;
      }
    } catch (e) {
      print('Error in createGalleryEntry: $e');
      return false;
    }
  }


  /// Edit an existing gallery entry
  Future<bool> editGalleryEntry(CookieRequest request, String id, Map<String, String> data, File? imageFile) async {
    final url = '$baseUrl/gallery/edit/$id/flutter/';
    final formData = FormData();

    // Add fields to FormData
    data.forEach((key, value) {
      formData.append(key, value);
    });

    // Add file if present
    if (imageFile != null) {
      formData.appendBlob('foto', imageFile);
    }

    try {
      final xhr = HttpRequest();
      xhr.open('POST', url);
      // xhr.setRequestHeader('X-CSRFToken', request.cookies['csrftoken'] ?? ''); // Pass CSRF token
      xhr.withCredentials = true; // Ensures cookies are sent with the request

      xhr.send(formData);

      await xhr.onLoadEnd.first;

      if (xhr.status == 200) {
        return true;
      } else {
        print(xhr);
        print('Error editing entry: ${xhr.responseText}');
        return false;
      }
    } catch (e) {
      print('Error in editGalleryEntry: $e');
      return false;
    }
  }

  /// Delete a gallery entry
  Future<bool> deleteGalleryEntry(CookieRequest request, String id) async {
    final url = '$baseUrl/gallery/delete/$id/flutter/';

    try {
      final xhr = HttpRequest();
      xhr.open('POST', url);
      // xhr.setRequestHeader('X-CSRFToken', request.cookies['csrftoken'] ?? '');
      xhr.withCredentials = true;

      xhr.send();

      await xhr.onLoadEnd.first;

      if (xhr.status == 200) {
        return true;
      } else {
        print('Error deleting entry: ${xhr.responseText}');
        return false;
      }
    } catch (e) {
      print('Error in deleteGalleryEntry: $e');
      return false;
    }
  }
}
