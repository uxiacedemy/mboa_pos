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
  });
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
}