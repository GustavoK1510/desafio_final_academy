import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/brasil_api_cep.dart';
import 'models/brasil_api_cnpj.dart';

/// Provides access to BrasilAPI services
class BrasilApiService {

  /// Class constructor
  BrasilApiService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://brasilapi.com.br/api';

  /// Retrieves company information using a CNPJ
  Future<BrasilApiCnpj> getCnpj(String cnpj) async {
    final cleanCnpj = cnpj.replaceAll(RegExp(r'\D'), '');

    final response = await _client.get(
      Uri.parse('$_baseUrl/cnpj/v1/$cleanCnpj'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to retrieve CNPJ information.',
      );
    }

    return BrasilApiCnpj
      .fromMap(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Retrieves address information using a ZIP code
  Future<BrasilApiCep> getCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');

    final response = await _client.get(
      Uri.parse('$_baseUrl/cep/v1/$cleanCep'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to retrieve CEP information.',
      );
    }

    return BrasilApiCep
      .fromMap(jsonDecode(response.body) as Map<String, dynamic>);
  }
}