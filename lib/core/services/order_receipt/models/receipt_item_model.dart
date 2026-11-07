class ReceiptItem {
  const ReceiptItem({
    required this.name,
    required this.brand,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.discountAmount,
    required this.total,
  });

  final String name;
  final String brand;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double discountAmount;
  final double total;
}