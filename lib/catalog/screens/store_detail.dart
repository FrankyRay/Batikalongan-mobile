import 'package:batikalongan_mobile/catalog/models/catalog_model.dart';
import 'package:batikalongan_mobile/catalog/screens/add_product.dart';
import 'package:batikalongan_mobile/catalog/screens/catalog_product.dart';
import 'package:batikalongan_mobile/catalog/screens/edit_store.dart';
import 'package:batikalongan_mobile/catalog/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoreDetail extends StatefulWidget {
  final Store store;

  const StoreDetail({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  Future<List<Product>> fetchStoreProducts() async {
    const String url = 'http://127.0.0.1:8000/catalog/products/json/';
    const String storeUrl = 'http://127.0.0.1:8000/catalog/json/';

    // First fetch stores to resolve foreign keys
    final storeResponse = await http.get(Uri.parse(storeUrl));
    if (storeResponse.statusCode != 200) {
      throw Exception('Failed to load stores');
    }
    final stores = storeFromJson(storeResponse.body);

    // Then fetch products
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final allProducts = productFromJson(response.body, stores);
      // Filter products by store
      return allProducts
          .where((product) => product.store.id == widget.store.id)
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  int currentPage = 1;
  final int totalPages = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreEditScreen(
                    store: widget.store,
                    id: widget.store.id,
                    initialName: widget.store.name,
                    initialAddress: widget.store.address,
                    initialProductCount: widget.store.productCount,
                    initialImage: widget.store.image,
                  ),
                ),
              );
            },
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Store Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.store.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.store),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.store.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.store.address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.store.productCount} Produk',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tambah Produk',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Products Grid
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: fetchStoreProducts(),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada produk untuk toko ini.'),
                  );
                }

                final products = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoreEditScreen extends StatelessWidget {
  final Store store;
  final String id;
  final String initialName;
  final String initialAddress;
  final int initialProductCount;
  final String initialImage;
  const StoreEditScreen({
    Key? key,
    required this.id,
    required this.initialName,
    required this.initialAddress,
    required this.initialProductCount,
    required this.initialImage,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Toko: ${store.name}'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: store.name),
              decoration: const InputDecoration(labelText: 'Nama Toko'),
            ),
            TextField(
              controller: TextEditingController(text: store.address),
              decoration: const InputDecoration(labelText: 'Alamat Toko'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan perubahan
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
