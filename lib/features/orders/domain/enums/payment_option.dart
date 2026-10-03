/// Represents a payment option
enum PaymentOption {
  /// Paid using a credit card
  creditCard,

  /// Paid using cash
  cash,

  /// Paid using TED bank transfer
  bankTransferTed,

  /// Paid using DOC bank transfer
  bankTransferDoc,

  /// Paid using PIX
  pix
}