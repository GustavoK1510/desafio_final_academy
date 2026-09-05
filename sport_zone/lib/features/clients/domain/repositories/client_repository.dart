import '../entities/client.dart';

/// Represents the contract for [ClientRepository]
abstract class ClientRepository {

  /// Inserts a [Client] into the database
  Future<void> insertClient(Client client);

  /// Retrieves all clients from the database
  Future<List<Client>> getClients();

  /// Updates a [Client]
  Future<void> updateClient(Client client);

  /// Deletes a [Client] by its [id]
  Future<void> deleteClient(int clientId);
}