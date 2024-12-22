import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String id;
  final String nama;
  final String deskripsi;
  final String tanggal;
  final String lokasi;
  final String fotoUrl;
  final bool isAdmin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCard({
    super.key,
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
    required this.lokasi,
    required this.fotoUrl,
    this.isAdmin = false,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Gambar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fotoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                        width: 1000,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),

              // Tombol Admin (Edit & Delete)
              if (isAdmin)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: const Color(0xFFFF8A00)),
                          onPressed: onEdit,
                        )
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: const Color(0xFFD50000)),
                          onPressed: onDelete,
                        )
                      ),
                    ],
                  ),
                ),
              // if (isAdmin)
              //   Column(
              //     children: [
              //       IconButton(
              //         onPressed: onEdit,
              //         icon: const Icon(Icons.edit, color: const Color(0x00FF8A00)),
              //       ),
              //       IconButton(
              //         onPressed: onDelete,
              //         icon: const Icon(Icons.delete, color: const Color(0x00D50000)),
              //       ),
              //     ],
              //   ),
            ],
          ),

          const SizedBox(width: 12),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  deskripsi,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                Row(
                  children: [
                    ClipRRect(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.black),
                          Text(
                            tanggal,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.black),
                          Text(
                            lokasi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD88E30),
                    ),
                    onPressed: () {},
                    child: Text('Daftar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
