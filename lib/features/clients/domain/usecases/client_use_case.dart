import 'package:geocoding/geocoding.dart';

import '../../../../core/services/brasil_api/brasil_api_service.dart';
import '../../../../core/services/brasil_api/models/brasil_api_cep.dart';
import '../../../../core/services/brasil_api/models/brasil_api_cnpj.dart';
import '../../../../core/services/geocoding/geocoding_service.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

/// Provides client-related application operations
class UseCaseClient {

  /// Class constructor
  UseCaseClient({
    required this._repository,
    required this._brasilApiService,
    required this._geocodingService,
  });

  final ClientRepository _repository;
  final BrasilApiService _brasilApiService;
  final GeocodingService _geocodingService;

  /// Adds a new [Client]
  Future<void> insertClient(Client client) async {
    final location = await getCoordinates(
      street: client.street,
      number: client.number,
      city: client.city,
      state: client.state,
    );

    final clientWithCoordinates = Client(
      name: client.name,
      cnpj: client.cnpj,
      companyName: client.companyName,
      phoneNumber: client.phoneNumber,
      email: client.email,
      street: client.street,
      number: client.number,
      city: client.city,
      state: client.state,
      zipCode: client.zipCode,
      latitude: location.latitude,
      longitude: location.longitude,
      businessType: client.businessType,
    );

    await _repository.insertClient(clientWithCoordinates);
  }

  /// Retrieves all clients
  Future<List<Client>> getClients() {
    return _repository.getClients();
  }

  /// Updates an existing [Client]
  Future<void> updateClient(Client client) {
    return _repository.updateClient(client);
  }

  /// Deletes a client by its [clientId]
  Future<void> deleteClient(int clientId) {
    return _repository.deleteClient(clientId);
  }

  /// Retrieves company information using a CNPJ
  Future<BrasilApiCnpj> getCompanyByCnpj(String cnpj) {
    return _brasilApiService.getCnpj(cnpj);
  }

  /// Retrieves address information using a ZIP code
  Future<BrasilApiCep> getAddressByCep(String cep) {
    return _brasilApiService.getCep(cep);
  }

  /// Retrieves coordinates for an address.
  Future<Location> getCoordinates({
    required String street,
    required String number,
    required String city,
    required String state,
  }) {
    return _geocodingService.getCoordinates(
      street: street,
      number: number,
      city: city,
      state: state,
    );
  }
}