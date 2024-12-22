import 'dart:convert'; // For JSON encoding
import 'dart:io'; // For file handling
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:batikalongan_mobile/config/config.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _storeIdController = TextEditingController();

  File? _selectedImage;

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
          const SnackBar(content: Text('Pilih gambar produk terlebih dahulu')),
        );
        return;
      }

      try {
        final backendUrl = '${Config.baseUrl}/catalog/create-product-flutter/';
        final request = http.MultipartRequest('POST', Uri.parse(backendUrl));

        // Add form fields
        request.fields['name'] = _nameController.text;
        request.fields['price'] = _priceController.text;
        request.fields['store_id'] = _storeIdController.text;

        // Add image file
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));

        final response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pop(context);
        } else {
          final responseBody = await response.stream.bytesToString();
          final error = jsonDecode(responseBody)['message'] ?? 'Kesalahan tidak diketahui';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan produk: $error')),
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
          'Tambah Produk',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
              _buildTextField('Nama Produk', _nameController, 'Nama produk wajib diisi'),
              const SizedBox(height: 16),
              _buildTextField('Harga Produk', _priceController, 'Harga produk wajib diisi',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('ID Toko', _storeIdController, 'ID toko wajib diisi',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload, color: Color(0xFFD88E30)),
                label: const Text(
                  'Pilih Gambar Produk',
                  style: TextStyle(color: Color(0xFFD88E30)),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Gambar Terpilih: ${_selectedImage!.path.split('/').last}',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD88E30),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(384, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String errorText,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFD88E30), fontSize: 16),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD88E30)),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? errorText : null,
        ),
      ],
    );
  }
}
