/// Represents address information returned by BrasilAPI
class BrasilApiCep {

  /// Cass constructor
  const BrasilApiCep({
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  /// CEP
  final String cep;

  /// Street
  final String street;

  /// Neighborhood
  final String neighborhood;

  /// City
  final String city;

  /// State
  final String state;

  /// Creates a [BrasilApiCep] from a BrasilAPI response
  factory BrasilApiCep.fromMap(Map<String, dynamic> map) {
    return BrasilApiCep(
      cep: map['cep'] as String,
      street: map['street'] as String,
      neighborhood: map['neighborhood'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
    );
  }
}