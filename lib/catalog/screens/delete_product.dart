import 'package:batikalongan_mobile/config/config.dart';
import 'package:http/http.dart' as http;

Future<void> deleteProductFlutter(String productId) async {
  const backendUrl = Config.baseUrl + '/catalog/delete-product-flutter/';
  final response = await http.post(Uri.parse('$backendUrl$productId/'));

  if (response.statusCode == 200) {
    print('Produk berhasil dihapus.');
  } else {
    throw Exception('Gagal menghapus produk: ${response.body}');
  }
}
