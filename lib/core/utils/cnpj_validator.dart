/// Validates Brazilian CNPJ numbers using their check digits.
class CnpjValidator {
  /// Returns whether [cnpj] has valid check digits.
  static bool isValid(String cnpj) {
    final digits = cnpj.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 14) return false;

    if (RegExp(r'^(\d)\1{13}$').hasMatch(digits)) {
      return false;
    }

    final firstDigit = _calculateDigit(
      digits.substring(0, 12),
      [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2],
    );

    final secondDigit = _calculateDigit(
      '${digits.substring(0, 12)}$firstDigit',
      [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2],
    );

    return digits.endsWith('$firstDigit$secondDigit');
  }

  static int _calculateDigit(String digits, List<int> weights) {
    var sum = 0;

    for (var i = 0; i < weights.length; i++) {
      sum += int.parse(digits[i]) * weights[i];
    }

    final remainder = sum % 11;
    return remainder < 2 ? 0 : 11 - remainder;
  }
}