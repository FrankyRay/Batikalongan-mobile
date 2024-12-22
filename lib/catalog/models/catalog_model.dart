import 'dart:convert';

// catalog_model.dart
/// Store Model
class Store {
  String id;
  String name;
  String address;
  int productCount;
  String image;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.productCount,
    required this.image,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["pk"],
        name: json["fields"]["name"],
        address: json["fields"]["address"],
        productCount: json["fields"]["product_count"],
        image: json["fields"]["image"],
      );

  /// Convert Store object to JSON
  Map<String, dynamic> toJson() => {
        "pk": id,
        "fields": {
          "name": name,
          "address": address,
          "product_count": productCount,
          "image": image,
        },
      };
}

/// Product Model
class Product {
  String id;
  String name;
  double price;
  String image;
  Store store; // Foreign key reference to Store

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.store,
  });

  factory Product.fromJson(Map<String, dynamic> json, Map<String, Store> storesMap) => Product(
        id: json["pk"],
        name: json["fields"]["name"],
        price: double.parse(json["fields"]["price"]),
        image: json["fields"]["image"],
        store: storesMap[json["fields"]["store_name"]]!, // Link to Store using foreign key
      );

  /// Convert Product object to JSON
  Map<String, dynamic> toJson() => {
        "pk": id,
        "fields": {
          "name": name,
          "price": price.toStringAsFixed(2),
          "image": image,
          "store_name": store.name,
        },
      };
}

/// Helper functions to parse JSON List to Dart Objects

/// Parse Store JSON List
List<Store> storeFromJson(String str) {
  List<dynamic> decodedJson = json.decode(str);
  return decodedJson.map((json) => Store.fromJson(json)).toList();
}

/// Convert Store Object List to JSON
String storeToJson(List<Store> data) =>
    json.encode(data.map((store) => store.toJson()).toList());

/// Parse Product JSON List with Foreign Key Resolution
List<Product> productFromJson(String str, List<Store> stores) {
  // Create a map of store names to Store objects for quick lookup
  Map<String, Store> storesMap = {for (var store in stores) store.name: store};

  // Parse product JSON and resolve the foreign key (store_name) to Store objects
  List<dynamic> decodedJson = json.decode(str)["products"];
  return decodedJson
      .map((json) => Product.fromJson(json, storesMap))
      .toList();
}

/// Convert Product Object List to JSON
String productToJson(List<Product> data) => json.encode({
      "products": data.map((product) => product.toJson()).toList(),
    });
