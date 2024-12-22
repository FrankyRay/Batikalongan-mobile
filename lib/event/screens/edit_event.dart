import 'dart:convert';
import 'dart:html' as html; // Hanya untuk platform web.
import 'package:batikalongan_mobile/event/models/event_entry.dart';
import 'package:batikalongan_mobile/event/screens/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditEventForm extends StatefulWidget {
  final EventEntry event;
  const EditEventForm({ super.key, required this.event });

  @override
  State<EditEventForm> createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  final _formKey = GlobalKey<FormState>();

  html.File? _selectedImage; // Variable to store selected image file.
  String _nama = "";
  String _deskripsi = "";
  String _tanggal = "";
  String _lokasi = "";

  Future<void> _pickImage() async {
    // File picker untuk web.
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      if (file != null) {
        setState(() {
          _selectedImage = file;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    _nama = widget.event.nama;
    _deskripsi = widget.event.deskripsi;
    _tanggal = widget.event.tanggal;
    _lokasi = widget.event.lokasi;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Event',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontFamily: 'Fabled',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        )
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              initialValue: widget.event.nama,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              onChanged: (value) {
                setState(() {
                  _nama = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.event.deskripsi,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
              onChanged: (value) {
                setState(() {
                  _deskripsi = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.event.tanggal,
              decoration: const InputDecoration(labelText: 'Tanggal'),
              validator: (value) {
                if (value == null) return null;
                if (value.isEmpty) return 'Tanggal wajib diisi!';
                try {
                  DateTime.parse(value);
                  return null;
                } catch (e) {
                  return 'Format tanggal harus YYYY-MM-DD atau serupa!';
                }
              },
              onChanged: (value) {
                setState(() {
                  _tanggal = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.event.lokasi,
              decoration: const InputDecoration(labelText: 'Lokasi'),
              validator: (value) => value == null || value.isEmpty ? 'Lokasi wajib diisi' : null,
              onChanged: (value) {
                setState(() {
                  _lokasi = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Pilih Gambar'),
            ),
            if (_selectedImage != null)
              Text(
                'Gambar Terpilih: ${_selectedImage!.name}',
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final response = await request.postJson(
                      "http://127.0.0.1:8000/event/edit-flutter/${widget.event.id}",
                      jsonEncode(<String, String>{
                        'nama': _nama,
                        'deskripsi': _deskripsi,
                        'tanggal': _tanggal,
                        'lokasi': _lokasi,
                      }),
                    );

                    if (!context.mounted) return;
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Mood baru berhasil disimpan!"),
                      ));

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => EventScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Terdapat kesalahan, silakan coba lagi."),
                      ));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terjadi kesalahan: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class CreateEventScreen extends StatefulWidget {
//   final VoidCallback onEntryAdded; // Callback untuk memberitahu perubahan.
//   const CreateEventScreen({super.key, required this.onEntryAdded});

//   @override
//   _AddEntryScreenState createState() => _AddEntryScreenState();
// }

// class _AddEntryScreenState extends State<CreateEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _service = EventService('http://127.0.0.1:8000/');
//   final TextEditingController _namaBatikController = TextEditingController();
//   final TextEditingController _deskripsiController = TextEditingController();
//   final TextEditingController _asalUsulController = TextEditingController();
//   final TextEditingController _maknaController = TextEditingController();

//   html.File? _selectedImage; // Variable to store selected image file.

//   Future<void> _pickImage() async {
//     // File picker untuk web.
//     final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
//     uploadInput.click();
//     uploadInput.onChange.listen((e) {
//       final file = uploadInput.files?.first;
//       if (file != null) {
//         setState(() {
//           _selectedImage = file;
//         });
//       }
//     });
//   }

//   Future<void> _submitForm() async {
//     final request = context.watch<CookieRequest>();

//     if (_formKey.currentState!.validate()) {
//       if (_selectedImage == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
//         );
//         return;
//       }

//       try {
//         final success = await _service.createGalleryEntry(request, {
//           'nama_batik': _namaBatikController.text,
//           'deskripsi': _deskripsiController.text,
//           'asal_usul': _asalUsulController.text,
//           'makna': _maknaController.text,
//         }, _selectedImage!);

//         if (success) {
//           widget.onEntryAdded(); // Panggil callback
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Berhasil menambahkan entri')),
//           );
//           Navigator.pop(context);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Gagal menambahkan entri')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Terjadi kesalahan: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Tambah Batik')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _namaBatikController,
//                 decoration: const InputDecoration(labelText: 'Nama Batik'),
//                 validator: (value) => value == null || value.isEmpty ? 'Nama batik wajib diisi' : null,
//               ),
//               TextFormField(
//                 controller: _deskripsiController,
//                 decoration: const InputDecoration(labelText: 'Deskripsi'),
//                 maxLines: 3,
//                 validator: (value) => value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
//               ),
//               TextFormField(
//                 controller: _asalUsulController,
//                 decoration: const InputDecoration(labelText: 'Asal Usul'),
//                 validator: (value) => value == null || value.isEmpty ? 'Asal usul wajib diisi' : null,
//               ),
//               TextFormField(
//                 controller: _maknaController,
//                 decoration: const InputDecoration(labelText: 'Makna'),
//                 validator: (value) => value == null || value.isEmpty ? 'Makna wajib diisi' : null,
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: _pickImage,
//                 child: const Text('Pilih Gambar'),
//               ),
//               if (_selectedImage != null)
//                 Text(
//                   'Gambar Terpilih: ${_selectedImage!.name}',
//                   style: const TextStyle(fontSize: 14, color: Colors.green),
//                 ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Simpan'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:batikalongan_mobile/event/models/event_entry.dart';
// import 'package:flutter/material.dart';

// class EditEntryScreen extends StatefulWidget {
//   final EventEntry event;
//   final VoidCallback onEntryUpdated; // Callback untuk memberitahu perubahan.
//   const EditEntryScreen({
//     super.key,
//     required this.event,
//     required this.onEntryUpdated, // Tambahkan ke konstruktor.
//   });

//   @override
//   _EditEntryScreenState createState() => _EditEntryScreenState();
// }

// class _EditEntryScreenState extends State<EditEntryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _service = GalleryService('http://127.0.0.1:8000/');
//   late TextEditingController _namaBatikController;
//   late TextEditingController _deskripsiController;
//   late TextEditingController _asalUsulController;
//   late TextEditingController _maknaController;
//   html.File? _selectedImage; // Variable to store selected image file.

//   @override
//   void initState() {
//     super.initState();
//     _namaBatikController = TextEditingController(text: widget.event.namaBatik);
//     _deskripsiController = TextEditingController(text: widget.event.deskripsi);
//     _asalUsulController = TextEditingController(text: widget.event.asalUsul);
//     _maknaController = TextEditingController(text: widget.event.makna);
//   }

//   Future<void> _pickImage() async {
//     // File picker for web.
//     final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
//     uploadInput.click();
//     uploadInput.onChange.listen((e) {
//       final file = uploadInput.files?.first;
//       if (file != null) {
//         setState(() {
//           _selectedImage = file;
//         });
//       }
//     });
//   }

//   Future<void> _submitForm() async {
//     final request = context.read<CookieRequest>();
//     if (_formKey.currentState!.validate()) {
//       try {
//         final success = await _service.editGalleryEntry(request,
//           widget.event.id,
//           {
//             'nama_batik': _namaBatikController.text,
//             'deskripsi': _deskripsiController.text,
//             'asal_usul': _asalUsulController.text,
//             'makna': _maknaController.text,
//           },
//           _selectedImage, // Include selected image if available.
//         );

//         if (success) {
//           widget.onEntryUpdated(); // Panggil callback
//           Navigator.pop(context);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to update entry')),
//           );
//         }
//       } catch (e) {
//         // Print error and show message.
//         print('Error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Batik')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _namaBatikController,
//                 decoration: const InputDecoration(labelText: 'Nama Batik'),
//                 validator: (value) => value == null || value.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _deskripsiController,
//                 decoration: const InputDecoration(labelText: 'Deskripsi'),
//                 maxLines: 3,
//                 validator: (value) => value == null || value.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _asalUsulController,
//                 decoration: const InputDecoration(labelText: 'Asal Usul'),
//                 validator: (value) => value == null || value.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _maknaController,
//                 decoration: const InputDecoration(labelText: 'Makna'),
//                 validator: (value) => value == null || value.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: _pickImage,
//                 child: const Text('Pilih Gambar (Opsional)'),
//               ),
//               if (_selectedImage != null)
//                 Text(
//                   'Gambar Terpilih: ${_selectedImage!.name}',
//                   style: const TextStyle(fontSize: 14, color: Colors.green),
//                 ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Simpan Perubahan'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
