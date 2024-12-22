import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../services/gallery_service.dart';
import 'package:batikalongan_mobile/config/config.dart';

class DeleteEntryScreen extends StatefulWidget {
  final String entryId;
  final VoidCallback onDeleteSuccess;

  const DeleteEntryScreen({
    Key? key,
    required this.entryId,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  _DeleteEntryScreenState createState() => _DeleteEntryScreenState();
}

class _DeleteEntryScreenState extends State<DeleteEntryScreen> {
  bool _isDeleting = false; // Indikator loading

  Future<void> _deleteEntry(BuildContext context) async {
    final request = context.read<CookieRequest>();
    final galleryService = GalleryService(Config.baseUrl);

    setState(() {
      _isDeleting = true; // Tampilkan indikator loading
    });

    try {
      final success = await galleryService.deleteGalleryEntry(request, widget.entryId);

      setState(() {
        _isDeleting = false; // Sembunyikan indikator loading
      });

      if (success) {
        widget.onDeleteSuccess();
        Navigator.pop(context); // Tutup dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entri berhasil dihapus!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus entri. Silakan coba lagi.')),
        );
      }
    } catch (e) {
      setState(() {
        _isDeleting = false; // Sembunyikan indikator loading
      });
      print('Error deleting entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        'Hapus Entri',
        style: const TextStyle(
          color: Color(0xFFD88E30), // Warna judul
          fontFamily: 'Poppins', // Font keluarga
          fontWeight: FontWeight.bold,
        ),
      ),
      content: _isDeleting
          ? const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()), // Loading spinner
            )
          : const Text(
              'Apakah Anda yakin ingin menghapus entri ini?',
              style: TextStyle(
                fontFamily: 'Poppins', // Font keluarga
                fontSize: 14,
              ),
            ),
      actions: _isDeleting
          ? [] // Tidak ada tombol saat loading
          : [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                child: Text(
                  'Batal',
                  style: const TextStyle(
                    fontFamily: 'Poppins', // Font keluarga
                    color: Colors.grey, // Warna tombol
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _deleteEntry(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD88E30), // Warna tombol
                  foregroundColor: Colors.white, // Warna teks
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins', // Font keluarga
                  ),
                ),
                child: const Text('Hapus'),
              ),
            ],
    );
  }
}
