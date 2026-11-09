class ReceiptData {
  final String receiptNumber;
  final DateTime issuedAt;
  final String organizationName;
  final String organizationNiu;
  final String organizationAddress;
  final String cashierName;
  final List<ReceiptLine> items;
  final int subtotalFCFA;
  final int discountFCFA;
  final int deliveryFCFA;
  final int taxFCFA;
  final double taxRate;
  final int totalFCFA;
  final String paymentMethod;
  final String? paymentReference;

  const ReceiptData({
    required this.receiptNumber,
    required this.issuedAt,
    required this.organizationName,
    required this.organizationNiu,
    required this.organizationAddress,
    required this.cashierName,
    required this.items,
    required this.subtotalFCFA,
    required this.discountFCFA,
    required this.deliveryFCFA,
    required this.taxFCFA,
    required this.taxRate,
    required this.totalFCFA,
    required this.paymentMethod,
    this.paymentReference,
  });

  factory ReceiptData.fromJson(Map<String, dynamic> json) {
    return ReceiptData(
      receiptNumber: json['receiptNumber'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      organizationName: json['organizationName'] as String,
      organizationNiu: json['organizationNiu'] as String,
      organizationAddress: json['organizationAddress'] as String,
      cashierName: json['cashierName'] as String,
      items: (json['items'] as List)
          .map((item) =>
              ReceiptLine.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
      subtotalFCFA: json['subtotalFCFA'] as int,
      discountFCFA: json['discountFCFA'] as int,
      deliveryFCFA: json['deliveryFCFA'] as int,
      taxFCFA: json['taxFCFA'] as int,
      taxRate: (json['taxRate'] as num).toDouble(),
      totalFCFA: json['totalFCFA'] as int,
      paymentMethod: json['paymentMethod'] as String,
      paymentReference: json['paymentReference'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'receiptNumber': receiptNumber,
        'issuedAt': issuedAt.toIso8601String(),
        'organizationName': organizationName,
        'organizationNiu': organizationNiu,
        'organizationAddress': organizationAddress,
        'cashierName': cashierName,
        'items': items.map((item) => item.toJson()).toList(),
        'subtotalFCFA': subtotalFCFA,
        'discountFCFA': discountFCFA,
        'deliveryFCFA': deliveryFCFA,
        'taxFCFA': taxFCFA,
        'taxRate': taxRate,
        'totalFCFA': totalFCFA,
        'paymentMethod': paymentMethod,
        'paymentReference': paymentReference,
      };
}

class ReceiptLine {
  final String name;
  final int quantity;
  final int unitPriceFCFA;
  final int subtotalFCFA;

  const ReceiptLine({
    required this.name,
    required this.quantity,
    required this.unitPriceFCFA,
    required this.subtotalFCFA,
  });

  factory ReceiptLine.fromJson(Map<String, dynamic> json) => ReceiptLine(
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        unitPriceFCFA: json['unitPriceFCFA'] as int,
        subtotalFCFA: json['subtotalFCFA'] as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unitPriceFCFA': unitPriceFCFA,
        'subtotalFCFA': subtotalFCFA,
      };
}
