import 'package:http/http.dart' as http;

Future<void> deleteProductFlutter(String productId) async {
  const backendUrl = 'http://127.0.0.1:8000/catalog/delete-product/';
  final response = await http.post(Uri.parse('$backendUrl$productId/'));

  if (response.statusCode == 200) {
    print('Produk berhasil dihapus.');
  } else {
    throw Exception('Gagal menghapus produk: ${response.body}');
  }
}
