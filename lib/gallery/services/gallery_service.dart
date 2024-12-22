<<<<<<< HEAD
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:html'; // Untuk `File` di web.
// import '../models/gallery_entry.dart';

// class GalleryService {
//   final String baseUrl;

//   GalleryService(this.baseUrl);
  
//   Future<bool> createGalleryEntry(Map<String, String> data, File image) async {
//     final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/gallery/add/ajax/'));

//     // Tambahkan field data
//     data.forEach((key, value) {
//       request.fields[key] = value;
//     });

//     // Tambahkan file gambar
//     final reader = FileReader();
//     reader.readAsDataUrl(image);
//     await reader.onLoadEnd.first;
//     final bytes = reader.result as String;

//     request.files.add(http.MultipartFile.fromBytes(
//       'foto',
//       base64Decode(bytes.split(',').last),
//       filename: image.name,
//     ));

//     try {
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString(); // Baca isi respons.

//       if (response.statusCode == 201) {
//         return true;
//       } else {
//         print('Error Response (${response.statusCode}): $responseBody'); // Cetak error dari respons.
//         return false;
//       }
//     } catch (e) {
//       print('Error in createGalleryEntry: $e'); // Cetak error lokal.
//       return false;
//     }
//   }

//   Future<bool> editGalleryEntry(String id, Map<String, String> data, File? imageFile) async {
//     final request = HttpRequest();
//     final formData = FormData();

//     // Tambahkan data teks.
//     data.forEach((key, value) {
//       formData.append(key, value);
//     });

//     // Tambahkan file gambar jika tersedia.
//     if (imageFile != null) {
//       formData.appendBlob('foto', imageFile);
//     }

//     request.open('POST', '$baseUrl/gallery/edit/$id/ajax/');
//     request.send(formData);

//     await request.onLoadEnd.first;

//     return request.status == 200;
//   }

//   Future<Map<String, dynamic>> fetchGalleryEntries({int page = 1}) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/gallery/json/?page=$page'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['entries'] is String) {
//           final escapedEntries = data['entries'] as String;
//           final entriesData = json.decode(escapedEntries) as List;
//           final entries = entriesData.map((entry) => GalleryEntry.fromJson(entry)).toList();

//           return {
//             'entries': entries,
//             'hasNext': data['has_next'],
//             'hasPrevious': data['has_previous'],
//             'currentPage': data['current_page'],
//             'numPages': data['num_pages'],
//           };
//         } else {
//           throw Exception('Invalid "entries" format in response.');
//         }
//       } else {
//         throw Exception('Failed to load gallery entries with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching gallery entries: $e');
//       rethrow;
//     }
//   }
// }
=======
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
    if (response != null && response['message'] == 'Deleted successfully') {
      return true;
    } else {
      print('Error deleting entry: ${response?['error'] ?? 'Unknown error'}');
      return false;
    }
  } catch (e) {
    print('Error in deleteGalleryEntry: $e');
    return false;
  }
}
}
>>>>>>> f7040ecc866004223017a11a8dc0615001dc53ca
