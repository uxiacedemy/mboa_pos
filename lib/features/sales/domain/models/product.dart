import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String nameEn;
  final int priceFCFA;
  final String category;
  final int stockQty;
  final String? barcode;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.priceFCFA,
    required this.category,
    required this.stockQty,
    this.barcode,
    this.imageUrl,
  });

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Product(
      id: snapshot.id,
      name: data['name'] as String,
      nameEn: data['nameEn'] as String? ?? data['name'] as String,
      priceFCFA: data['priceXAF'] as int,
      category: data['category'] as String,
      stockQty: data['stockQty'] as int,
      barcode: data['barcode'] as String?,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'nameEn': nameEn,
        'priceXAF': priceFCFA,
        'category': category,
        'stockQty': stockQty,
        'barcode': barcode,
        'imageUrl': imageUrl,
      };
}
