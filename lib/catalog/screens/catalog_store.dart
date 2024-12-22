import 'dart:convert';
import 'package:batikalongan_mobile/auth/screens/login.dart';
import 'package:batikalongan_mobile/catalog/models/catalog_model.dart';
import 'package:batikalongan_mobile/catalog/screens/add_store.dart';
import 'package:batikalongan_mobile/catalog/screens/catalog_product.dart';
import 'package:batikalongan_mobile/catalog/widgets/store_card.dart';
import 'package:batikalongan_mobile/gallery/screens/gallery_screen.dart';
import 'package:batikalongan_mobile/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:batikalongan_mobile/config/config.dart';
import 'package:batikalongan_mobile/article/screens/artikel_screen.dart';
import 'package:batikalongan_mobile/timeline/screens/timeline_screen.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class CatalogStores extends StatefulWidget {
  const CatalogStores({Key? key}) : super(key: key);

  @override
  State<CatalogStores> createState() => _CatalogStoresState();
}

class _CatalogStoresState extends State<CatalogStores> {
  Future<List<Store>> fetchStores() async {
    const String url = Config.baseUrl + '/catalog/json/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Store.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data toko');
    }
  }

  int currentPage = 1;
  final int totalPages = 7;
  int _currentIndex = 0; // Set the index for this page to 0

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              'Halo, ',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              'Aileen',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.orange),
            onPressed: () async {
              final response = await request
                  .logout("http://127.0.0.1:8000/auth/api/logout/");
              String message = response["message"];
              if (context.mounted) {
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Toko Batik'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductCatalog()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.orange),
                    ),
                    child: const Text(
                      'Produk Batik',
                      style: TextStyle(color: Colors.orange),
                    ),
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
                  MaterialPageRoute(builder: (context) => const AddStorePage()),
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
                'Tambah Toko',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Store>>(
              future: fetchStores(),
              builder: (context, AsyncSnapshot<List<Store>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada data toko yang tersedia.'));
                }

                final stores = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
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
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                ),
                for (int i = 1; i <= totalPages; i++)
                  if (i == 1 ||
                      i == totalPages ||
                      (i >= currentPage - 1 && i <= currentPage + 1))
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color:
                              currentPage == i ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '$i',
                            style: TextStyle(
                              color: currentPage == i
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (i == currentPage - 2 || i == currentPage + 2)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text('...'),
                    ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // Current page, do nothing
          }
          if (index == 1) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ProductCatalog()),
            // );
          }
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GalleryScreen()),
            );
          }
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ArtikelScreen()),
            );
          }
          if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimeLineScreen()),
            );
          }
        },
      ),
    );
  }
}
