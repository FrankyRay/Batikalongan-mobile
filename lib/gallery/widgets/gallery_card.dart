import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalleryCard extends StatelessWidget {
  final String id;
  final String namaBatik;
  final String deskripsi;
  final String asalUsul;
  final String makna;
  final String fotoUrl;
  final bool isAdmin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GalleryCard({
    super.key,
    required this.id,
    required this.namaBatik,
    required this.deskripsi,
    required this.asalUsul,
    required this.makna,
    required this.fotoUrl,
    this.isAdmin = false,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFD9D9D9)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 120, // Lebar tetap
                    child: AspectRatio(
                      aspectRatio: 9 / 16, // Atur rasio aspek sesuai kebutuhan
                      child: Image.network(
                        fotoUrl,
                        fit: BoxFit.cover, // Gambar memenuhi ruang tanpa distorsi
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),

              const SizedBox(width: 12),

              // Detail Batik
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Batik
                    Text(
                      namaBatik,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Deskripsi
                    Text(
                      deskripsi,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Makna
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Makna: $makna',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Asal Usul
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Asal Usul: $asalUsul',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Admin Buttons (Edit and Delete)
        if (isAdmin)
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/edit.svg',
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/delete.svg',
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
