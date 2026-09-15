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

final dummyProducts = [
  const Product(id: '1',  name: 'Coca-Cola 50cl',        nameEn: 'Coca-Cola 50cl',       priceFCFA: 500, category: 'boissons',    stockQty: 48),
  const Product(id: '2',  name: 'Eau Supermont 1.5L',    nameEn: 'Supermont Water 1.5L', priceFCFA: 350, category: 'boissons',    stockQty: 60),
  const Product(id: '3',  name: 'Bière 33 Export 65cl',  nameEn: '33 Export Beer 65cl',  priceFCFA: 700, category: 'boissons',    stockQty: 144),
  const Product(id: '4',  name: 'Riz parfumé 1kg',       nameEn: 'Fragrant Rice 1kg',    priceFCFA: 550, category: 'alimentaire', stockQty: 40),
  const Product(id: '5',  name: 'Farine de blé 1kg',     nameEn: 'Wheat Flour 1kg',      priceFCFA: 650, category: 'alimentaire', stockQty: 20),
  const Product(id: '6',  name: 'Huile de palme 1L',     nameEn: 'Palm Oil 1L',          priceFCFA: 900, category: 'alimentaire', stockQty: 15),
  const Product(id: '7',  name: 'Sucre 1kg',             nameEn: 'Sugar 1kg',            priceFCFA: 600, category: 'alimentaire', stockQty: 25),
  const Product(id: '8',  name: 'Tomate concentrée 70g', nameEn: 'Tomato Paste 70g',     priceFCFA: 200, category: 'alimentaire', stockQty: 50),
  const Product(id: '9',  name: 'Savon Omo 500g',        nameEn: 'Omo Soap 500g',        priceFCFA: 750, category: 'hygiène',     stockQty: 35),
  const Product(id: '10', name: 'Biscuits Digestive',    nameEn: 'Digestive Biscuits',   priceFCFA: 250, category: 'alimentaire', stockQty: 30),
];
