import 'package:batikalongan_mobile/article/screens/artikel_screen.dart';
import 'package:batikalongan_mobile/catalog/screens/product.dart';
import 'package:batikalongan_mobile/event/models/event_entry.dart';
import 'package:batikalongan_mobile/event/screens/create_event.dart';
import 'package:batikalongan_mobile/event/screens/edit_event.dart';
import 'package:batikalongan_mobile/event/services/event_service.dart';
import 'package:batikalongan_mobile/event/widgets/event_card.dart';
import 'package:batikalongan_mobile/gallery/screens/gallery_screen.dart';
import 'package:batikalongan_mobile/timeline/screens/timeline_screen.dart';
import 'package:batikalongan_mobile/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import '../widgets/gallery_card.dart';
// import '../widgets/pagination_controls.dart';
// import '../services/gallery_service.dart';
// import '../models/gallery_entry.dart';
// import 'edit_entry_screen.dart';
// import 'add_entry_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final String _url = 'http://127.0.0.1:8000/';
  final EventService _service = EventService('http://127.0.0.1:8000/'); // Base URL API
  int _currentIndex = 2;

  List<EventEntry> _entries = [];
  // int _currentPage = 1;
  // int _totalPages = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _service.fetchEventEntry();
      setState(() {
        _entries = data;
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

    bool isAdmin = false;
    if (request.cookies['is_admin'] != null) {
      isAdmin = bool.parse(request.cookies['is_admin']!.value);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     'Event Batik',
      //     style: TextStyle(
      //       fontFamily: 'Fabled', // Menggunakan font custom
      //       color: Colors.black,
      //       fontSize: 40,
      //       fontWeight: FontWeight.w400,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          width: double.infinity,
          height: 110,
          color: Colors.white,
          padding:
              const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Judul Artikel
              Expanded(
                child: Text(
                  'Event Batik',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Fabled',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),

              if (isAdmin)
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateEventForm(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 2, color: Color(0xFFD88E30)),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add,
                            size: 24, color: Color(0xFFD88E30)),
                        const SizedBox(width: 8),
                        const Text(
                          'Tambah Artikel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFD88E30),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // ListView untuk Event Batik
                  Expanded(
                    child: ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return EventCard(
                          id: entry.id,
                          nama: entry.nama,
                          deskripsi: entry.deskripsi,
                          tanggal: entry.tanggal,
                          lokasi: entry.lokasi,
                          fotoUrl: '${_url}media/${entry.fotoUrl}',
                          isAdmin: isAdmin,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEventForm(event: entry),
                              ),
                            );
                          },
                          onDelete: () {
                            // Logika delete
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CatalogScreen()),
            );
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
