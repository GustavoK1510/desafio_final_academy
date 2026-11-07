/// Represents an item in the PDF receipt
class ReceiptItem {

  /// Class constructor
  const ReceiptItem({
    required this.name,
    required this.brand,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.discountAmount,
    required this.total,
  });

  /// Name
  final String name;

  /// Brand
  final String brand;

  /// Quantity
  final int quantity;

  /// Unit price
  final double unitPrice;

  /// Discount
  final double discount;

  /// Discount amount
  final double discountAmount;

  /// Total price
  final double total;
}