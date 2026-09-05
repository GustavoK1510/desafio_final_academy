import 'package:sqflite/sqflite.dart';

import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../models/client_model.dart';

/// The implementation for [ClientRepository]
class ClientRepositoryImpl implements ClientRepository {

  /// A [Database] instance
  final Database db;

  /// Class constructor
  ClientRepositoryImpl({required this.db});

  @override
  Future<void> insertClient(Client client) async {

    /// Creates a ClientModel
    final clientModel = ClientModel(
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
      latitude: client.latitude, 
      longitude: client.longitude, 
      businessType: client.businessType
    );

    /// Inserts the model into the database
    await db.insert(
      'clients',
      clientModel.toMap(),
    );
  }
  
  @override
  Future<List<Client>> getClients() async {

    /// Gets all the clients
    final clientMaps = await db.query('clients');

    /// Creates an empty List
    final clients = <Client>[];

    /// Converts each client into a ClientModel instance and adds it to the List
    for (final clientMap in clientMaps) {
      final client = ClientModel.fromMap(clientMap);
      clients.add(client);
    }

    /// Returns the List
    return clients;
  }
  
  @override
  Future<void> updateClient(Client client) async {

    /// Checks if the client has an ID
    if(client.id == null) {
      throw ArgumentError('Client ID is required to update a client');
    }

    /// Updates the client
    await db.update(
      'clients',
      {
        'name': client.name,
        'cnpj': client.cnpj,
        'company_name': client.companyName,
        'phone_number': client.phoneNumber,
        'email': client.email,
        'street': client.street,
        'number': client.number,
        'city': client.city,
        'state': client.state,
        'zip_code': client.zipCode,
        'latitude': client.latitude,
        'longitude': client.longitude,
        'business_type': client.businessType.name
      },
      where: 'id = ?',
      whereArgs: [client.id!],

    );
  }

  @override
  Future<void> deleteClient(int clientId) async {

    /// Deletes the client
    await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [clientId],
    );
  }
  
}