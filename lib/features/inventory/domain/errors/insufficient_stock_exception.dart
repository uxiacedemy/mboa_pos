class InsufficientStockException implements Exception {
  final String productId;
  final int requested;
  final int available;

  const InsufficientStockException({
    required this.productId,
    required this.requested,
    required this.available,
  });

  @override
  String toString() =>
      'Insufficient stock for product $productId: requested $requested, '
      'available $available';
}
