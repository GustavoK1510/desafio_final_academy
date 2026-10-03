import 'package:flutter/foundation.dart';

import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';

/// Manages the client list.
class ClientsProvider extends ChangeNotifier {
  /// Creates a clients provider.
  ClientsProvider({
    required this._useCase,
  });

  final UseCaseClient _useCase;

  List<Client> _clients = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Current clients.
  List<Client> get clients => List.unmodifiable(_clients);

  /// Whether clients are loading.
  bool get isLoading => _isLoading;

  /// Current error message.
  String? get errorMessage => _errorMessage;

  /// Loads all clients.
  Future<void> loadClients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clients = await _useCase.getClients();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a client.
  Future<bool> deleteClient(int id) async {
    try {
      await _useCase.deleteClient(id);
      _clients.removeWhere((client) => client.id == id);
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}