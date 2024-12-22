import 'dart:html' as html; // For file picker on web platforms
import 'package:flutter/material.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({Key? key}) : super(key: key);

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  html.File? _selectedImage; // Variable to store the selected image file
  int _productCount = 0; // Variable to store the product count

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
          const SnackBar(content: Text('Pilih gambar toko terlebih dahulu')),
        );
        return;
      }

      // Replace this URL with your backend endpoint for creating a store
      const backendUrl = 'http://127.0.0.1:8000/catalog/create-store-flutter/';

      try {
        // Simulate a request to your backend
        // Implement this logic using your preferred HTTP library
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Toko berhasil ditambahkan')),
        );
        Navigator.pop(context);
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Nama Toko',
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
                    ? 'Nama toko wajib diisi'
                    : null,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),

              // Jumlah Produk Field
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Jumlah Produk',
                  style: TextStyle(
                    color: const Color(0xFFD88E30),
                    fontFamily: 'Poppins',
                  ),
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
                          borderSide: BorderSide(
                              color: const Color(0xFFD88E30)), // Border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFFD88E30)), // Border color
                        ),
                      ),
                      controller: TextEditingController(
                        text: _productCount.toString(),
                      ),
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
              const SizedBox(height: 16),

              // Lokasi Toko Field
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Lokasi Toko',
                  style: TextStyle(
                    color: const Color(0xFFD88E30),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              TextFormField(
                controller: _locationController,
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
                    ? 'Lokasi toko wajib diisi'
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
                  'Pilih Gambar Toko',
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
