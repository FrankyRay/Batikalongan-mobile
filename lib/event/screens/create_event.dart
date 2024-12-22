import 'dart:convert';
import 'dart:html' as html; // Hanya untuk platform web.
import 'package:batikalongan_mobile/event/screens/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Event',
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
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi!' : null,
              onChanged: (value) {
                setState(() {
                  _nama = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Deskripsi wajib diisi!' : null,
              onChanged: (value) {
                setState(() {
                  _deskripsi = value;
                });
              },
            ),
            TextFormField(
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
              decoration: const InputDecoration(labelText: 'Lokasi'),
              validator: (value) => value == null || value.isEmpty ? 'Lokasi wajib diisi!' : null,
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
                      "http://127.0.0.1:8000/event/create-flutter/",
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



                    // final success = await _service.createEventEntry(request, {
                    //   'nama': _nama,
                    //   'deskripsi': _deskripsi,
                    //   'tanggal': _tanggal,
                    //   'lokasi': _lokasi,
                    // }, _selectedImage!);

                    // if (success) {
                    //   // widget.onEntryAdded(); // Panggil callback
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Berhasil menambahkan event')),
                    //   );
                    //   Navigator.pop(context);
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Gagal menambahkan event')),
                    //   );
                    // }
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
