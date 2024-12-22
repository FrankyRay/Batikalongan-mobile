import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/gallery_card.dart';
import '../widgets/pagination_controls.dart';
import '../services/gallery_service.dart';
import '../models/gallery_entry.dart';
import 'edit_entry_screen.dart';
import 'add_entry_screen.dart';
import 'delete_entry_screen.dart';
import 'package:batikalongan_mobile/timeline/screens/timeline_screen.dart';
import 'package:batikalongan_mobile/widgets/bottom_navbar.dart';
import 'package:batikalongan_mobile/article/screens/artikel_screen.dart';
import 'package:batikalongan_mobile/catalog/screens/catalog_store.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryService _service = GalleryService('http://127.0.0.1:8000/'); // Base URL API
  List<GalleryEntry> _entries = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = true;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries({int page = 1}) async {
    final request = context.read<CookieRequest>();
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _service.fetchGalleryEntries(request, page: page);
      setState(() {
        _entries = data['entries'];
        _currentPage = data['currentPage'];
        _totalPages = data['numPages'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching entries: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Check if the user is an admin
    final isAdmin = request.cookies['is_admin']!.value == 'true';
    print(request.cookies['is_admin']!.value);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Galeri Batik',
          style: TextStyle(
            fontFamily: 'Fabled', // Custom font
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Show "Tambah Batik" button only for admin users
                  if (isAdmin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEntryScreen(
                                onEntryAdded: _fetchEntries, // Refresh gallery
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD88E30), width: 2),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tambah Batik',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFD88E30),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // ListView for Gallery Entries
                  Expanded(
                    child: ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return GalleryCard(
                          id: entry.id,
                          namaBatik: entry.namaBatik,
                          deskripsi: entry.deskripsi,
                          asalUsul: entry.asalUsul,
                          makna: entry.makna,
                          fotoUrl: 'http://127.0.0.1:8000/media/${entry.fotoUrl}',
                          isAdmin: isAdmin,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEntryScreen(
                                  entry: entry,
                                  onEntryUpdated: _fetchEntries, // Refresh gallery
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) => DeleteEntryScreen(
                                entryId: entry.id.toString(),
                                onDeleteSuccess: _fetchEntries, // Refresh gallery after deletion
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Pagination Controls
                  PaginationControls(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onPageChange: (page) {
                      _fetchEntries(page: page);
                    },
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const CatalogScreen()),
            // );
          }
          if (index == 1) {
            // Tetap di halaman ini
          }
          if (index == 2) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const EventScreen()),
            // );
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
