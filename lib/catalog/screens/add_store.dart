import 'dart:convert';
import 'dart:io'; // For non-web platforms
import 'package:batikalongan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:batikalongan_mobile/config/config.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({Key? key}) : super(key: key);

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  File? _selectedImage;
  int _productCount = 0;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada file yang dipilih')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih gambar toko terlebih dahulu')),
        );
        return;
      }

      try {
        // URL backend
        const backendUrl = Config.baseUrl +  '/catalog/create-store-flutter/';

        // Membuat form data untuk pengunggahan

        final request = http.MultipartRequest('POST', Uri.parse(backendUrl))
          ..fields['name'] = _nameController.text
          ..fields['address'] = _locationController.text
          ..fields['product_count'] = _productCount.toString();

        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ));
        }

        final response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Toko berhasil ditambahkan')),
          );
          Navigator.pop(context);
        } else {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = jsonDecode(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Gagal menambahkan toko: ${jsonResponse["message"] ?? "Kesalahan tidak diketahui"}'),
            ),
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
      appBar: AppBar(
        title: const Text(
          'Tambah Toko',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontFamily: 'Fabled',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        backgroundColor: const Color(0xFFD88E30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Toko Field
              _buildTextField('Nama Toko', _nameController, 'Nama toko wajib diisi'),

              const SizedBox(height: 16),

              // Jumlah Produk Field
              _buildProductCountField(),

              const SizedBox(height: 16),

              // Lokasi Toko Field
              _buildTextField('Lokasi Toko', _locationController, 'Lokasi toko wajib diisi'),

              const SizedBox(height: 16),

              // Image Picker Button
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload, color: const Color(0xFFD88E30)),
                label: const Text(
                  'Pilih Gambar Toko',
                  style: TextStyle(color: Color(0xFFD88E30), fontFamily: 'Poppins'),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Gambar Terpilih: ${_selectedImage!.path.split('/').last}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Submit Button
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
                    textStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build text fields
  Widget _buildTextField(String label, TextEditingController controller, String errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(color: const Color(0xFFD88E30), fontFamily: 'Poppins'),
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFFD88E30)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFFD88E30)),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? errorText : null,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
      ],
    );
  }

  // Helper to build product count field
  Widget _buildProductCountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Jumlah Produk',
            style: TextStyle(color: const Color(0xFFD88E30), fontFamily: 'Poppins'),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (_productCount > 0) _productCount--;
                });
              },
              icon: const Icon(Icons.remove),
              color: const Color(0xFFD88E30),
            ),
            Expanded(
              child: TextFormField(
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFFD88E30)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFFD88E30)),
                  ),
                ),
                controller: TextEditingController(text: _productCount.toString()),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _productCount++;
                });
              },
              icon: const Icon(Icons.add),
              color: const Color(0xFFD88E30),
            ),
          ],
        ),
      ],
    );
  }
}
