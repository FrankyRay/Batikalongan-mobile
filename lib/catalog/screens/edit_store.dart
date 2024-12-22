// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<Map<String, dynamic>> sendPutRequest(
//     String url, Map<String, dynamic> data) async {
//   final response = await http.put(
//     Uri.parse(url),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode(data),
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Failed to update: ${response.body}');
//   }
// }

// class StoreEditScreen extends StatefulWidget {
//   final String id;
//   final String initialName;
//   final String initialAddress;
//   final int initialProductCount;
//   final String initialImage;

//   const StoreEditScreen({
//     Key? key,
//     required this.id,
//     required this.initialName,
//     required this.initialAddress,
//     required this.initialProductCount,
//     required this.initialImage,
//   }) : super(key: key);

//   @override
//   _StoreEditScreenState createState() => _StoreEditScreenState();
// }

// class _StoreEditScreenState extends State<StoreEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _nameController;
//   late TextEditingController _addressController;
//   late TextEditingController _productCountController;
//   late TextEditingController _imageController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.initialName);
//     _addressController = TextEditingController(text: widget.initialAddress);
//     _productCountController = TextEditingController(
//       text: widget.initialProductCount.toString(),
//     );
//     _imageController = TextEditingController(text: widget.initialImage);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _productCountController.dispose();
//     _imageController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final data = {
//         "name": _nameController.text,
//         "address": _addressController.text,
//         "product_count": int.parse(_productCountController.text),
//       };

//       try {
//         final response = await sendPutRequest(
//             'http://your-api-url/update-store/${widget.id}/', data);

//         if (response['status'] == 'success') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Store updated successfully!')),
//           );
//           Navigator.pop(context);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content:
//                     Text('Failed to update store: ${response['message']}')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Store')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Name cannot be empty' : null,
//               ),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: 'Address'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Address cannot be empty' : null,
//               ),
//               TextFormField(
//                 controller: _productCountController,
//                 decoration: const InputDecoration(labelText: 'Product Count'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) => int.tryParse(value!) == null
//                     ? 'Enter a valid number'
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _imageController,
//                 decoration: const InputDecoration(labelText: 'Image URL'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Image URL cannot be empty' : null,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
