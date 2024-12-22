import 'package:batikalongan_mobile/catalog/models/store.dart';
import 'package:batikalongan_mobile/catalog/widgets/store_card.dart';
import 'package:flutter/material.dart';

class CatalogStores extends StatelessWidget {
  final List<Store> stores; // List of Store objects

  const CatalogStores({Key? key, required this.stores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Batik'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton(context, 'Toko Batik', true),
                const SizedBox(width: 8),
                _buildCategoryButton(context, 'Produk Batik', false),
              ],
            ),
            const SizedBox(height: 16),
            // Grid of Stores
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  return StoreCard(store: stores[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String title, bool isActive) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.orange : Colors.white,
          foregroundColor: isActive ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isActive ? Colors.transparent : Colors.grey.shade400,
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
