class EventEntry {
  final String id;
  final String nama;
  final String deskripsi;
  final String tanggal;
  final String lokasi;
  final String fotoUrl;

  EventEntry({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
    required this.lokasi,
    required this.fotoUrl,
  });

  factory EventEntry.fromJson(Map<String, dynamic> json) {
    return EventEntry(
      id: json['pk'],
      nama: json['fields']['nama'],
      deskripsi: json['fields']['deskripsi'],
      tanggal: json['fields']['tanggal'],
      lokasi: json['fields']['lokasi'],
      fotoUrl: json['fields']['foto'],
    );
  }
}
