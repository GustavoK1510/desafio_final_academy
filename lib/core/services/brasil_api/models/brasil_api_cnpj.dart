/// Represents company information returned by BrasilAPI
class BrasilApiCnpj {

  /// Class constructor
  const BrasilApiCnpj({
    required this.cnpj,
    required this.companyName,
    required this.tradeName,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  /// CNPJ
  final String cnpj;

  /// Company name
  final String companyName;

  /// Trade name
  final String tradeName;

  /// Street
  final String street;

  /// Number
  final String number;

  /// Neighborhood
  final String neighborhood;

  /// City
  final String city;

  /// State
  final String state;

  /// Zip Code
  final String zipCode;

  /// Creates a [BrasilApiCnpj] from a BrasilAPI response
  factory BrasilApiCnpj.fromMap(Map<String, dynamic> map) {
    return BrasilApiCnpj(
      cnpj: map['cnpj'] as String,
      companyName: map['razao_social'] as String,
      tradeName: map['nome_fantasia'] as String,
      street: map['logradouro'] as String,
      number: map['numero'] as String,
      neighborhood: map['bairro'] as String,
      city: map['municipio'] as String,
      state: map['uf'] as String,
      zipCode: map['cep'] as String,
    );
  }
}