import 'dart:convert'; // For JSON encoding
import 'dart:html' as html; // For file picker
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests

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

  html.File? _selectedImage;

  Future<void> _pickImage() async {
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih gambar produk terlebih dahulu')),
        );
        return;
      }

      try {
        // Convert the image file to base64 for JSON compatibility
        final reader = html.FileReader();
        reader.readAsDataUrl(_selectedImage!);
        await reader.onLoad.first;

        final base64Image = (reader.result as String).split(',').last;

        // Prepare the payload
        final payload = {
          "name": _nameController.text,
          "price": _priceController.text,
          "image": base64Image,
          "store_id": _storeIdController.text,
        };

        // Send the HTTP POST request
        const backendUrl = 'http://127.0.0.1:8000/catalog/create-product-flutter/';
        final response = await http.post(
          Uri.parse(backendUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        // Handle the response
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 && responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['message']}')),
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
              // Nama Produk Field
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Nama Produk',
                  style: TextStyle(
                    color: const Color(0xFFD88E30),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFFD88E30)), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFFD88E30)), // Border color
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama produk wajib diisi'
                    : null,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),

              // Harga Produk Field
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Harga Produk',
                  style: TextStyle(
                    color: const Color(0xFFD88E30),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFFD88E30)), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFFD88E30)), // Border color
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Harga produk wajib diisi'
                    : null,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),

              // Store ID Field
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'ID Toko',
                  style: TextStyle(
                    color: const Color(0xFFD88E30),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              TextFormField(
                controller: _storeIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFFD88E30)), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFFD88E30)), // Border color
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'ID toko wajib diisi'
                    : null,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),

              // Image Picker Button
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.upload,
                  color: const Color(0xFFD88E30),
                ),
                label: Text(
                  'Pilih Gambar Produk',
                  style: TextStyle(
                    color: const Color(0xFFD88E30),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Gambar Terpilih: ${_selectedImage!.name}',
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
}
