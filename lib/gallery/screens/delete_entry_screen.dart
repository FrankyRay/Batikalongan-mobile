import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../services/gallery_service.dart';

class DeleteEntryScreen extends StatelessWidget {
  final String entryId;
  final VoidCallback onDeleteSuccess;

  const DeleteEntryScreen({
    Key? key,
    required this.entryId,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final galleryService = GalleryService('http://127.0.0.1:8000/'); // Base URL

    return AlertDialog(
      title: const Text('Hapus Entri'),
      content: const Text('Apakah Anda yakin ingin menghapus entri ini?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            final success = await galleryService.deleteGalleryEntry(request, entryId);

            if (success) {
              onDeleteSuccess();
              Navigator.pop(context); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entri berhasil dihapus!')),
              );
            } else {
              Navigator.pop(context); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gagal menghapus entri.')),
              );
            }
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
