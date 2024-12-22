<<<<<<< HEAD
// import 'dart:html' as html; // Hanya untuk platform web.
// import 'package:flutter/material.dart';
// import '../services/gallery_service.dart';

// class AddEntryScreen extends StatefulWidget {
//   final VoidCallback onEntryAdded; // Callback untuk memberitahu perubahan.
//   const AddEntryScreen({super.key, required this.onEntryAdded});

//   @override
//   _AddEntryScreenState createState() => _AddEntryScreenState();
// }

// class _AddEntryScreenState extends State<AddEntryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _service = GalleryService('https://faiz-assabil-batikalongantest.pbp.cs.ui.ac.id');
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
//     if (_formKey.currentState!.validate()) {
//       if (_selectedImage == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
//         );
//         return;
//       }

//       try {
//         final success = await _service.createGalleryEntry({
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
=======
import 'dart:io'; // For non-web platforms
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/gallery_service.dart';
import 'package:provider/provider.dart';
import 'package:batikalongan_mobile/config/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddEntryScreen extends StatefulWidget {
  final VoidCallback onEntryAdded;

  const AddEntryScreen({Key? key, required this.onEntryAdded}) : super(key: key);

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = GalleryService(Config.baseUrl);
  final _namaBatikController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _asalUsulController = TextEditingController();
  final _maknaController = TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada file yang dipilih')),
      );
    }
  }

  Future<void> _submitForm() async {
    final request = context.read<CookieRequest>();
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
        );
        return;
      }

      try {
        final success = await _service.createGalleryEntry(
          request,
          {
            'nama_batik': _namaBatikController.text,
            'deskripsi': _deskripsiController.text,
            'asal_usul': _asalUsulController.text,
            'makna': _maknaController.text,
          },
          _selectedImage!,
        );

        if (success) {
          widget.onEntryAdded();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil menambahkan entri')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menambahkan entri')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Batik')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Nama Batik'),
              _buildTextField(_namaBatikController, 'Nama batik wajib diisi'),
              const SizedBox(height: 16),
              _buildLabel('Deskripsi'),
              _buildTextField(_deskripsiController, 'Deskripsi wajib diisi', maxLines: 3),
              const SizedBox(height: 16),
              _buildLabel('Asal Usul'),
              _buildTextField(_asalUsulController, 'Asal usul wajib diisi'),
              const SizedBox(height: 16),
              _buildLabel('Makna'),
              _buildTextField(_maknaController, 'Makna wajib diisi'),
              const SizedBox(height: 16),
              _buildLabel('Foto'),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload, color: Color(0xFFD88E30)),
                    label: const Text(
                      'Upload Foto',
                      style: TextStyle(
                        color: Color(0xFFD88E30),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontFamily: 'Poppins'),
                      side: const BorderSide(color: Color(0xFFD88E30), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_selectedImage != null)
                    const Text(
                      'Gambar Dipilih',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD88E30),
                    foregroundColor: Colors.white,
                    fixedSize: const Size(384, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFD88E30),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String validationMessage, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD88E30)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD88E30)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Poppins'),
    );
  }
}
>>>>>>> f7040ecc866004223017a11a8dc0615001dc53ca
