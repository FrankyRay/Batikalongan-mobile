import 'package:http/http.dart' as http;

Future<void> deleteStoreFlutter(String storeId) async {
  const backendUrl = 'http://127.0.0.1:8000/catalog/delete-store/';
  final response = await http.post(Uri.parse('$backendUrl$storeId/'));

  if (response.statusCode == 200) {
    print('Toko berhasil dihapus.');
  } else {
    throw Exception('Gagal menghapus toko: ${response.body}');
  }
}
