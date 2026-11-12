import 'package:flutter/foundation.dart';

import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';

/// Manages the delivery service list.
class DeliveryServicesProvider extends ChangeNotifier {

  /// Creates a delivery services provider.
  DeliveryServicesProvider({
    required this._useCase,
  });

  final DeliveryServiceUseCase _useCase;

  List<DeliveryService> _deliveryServices = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  /// Getter for the filtered orders list
  List<DeliveryService> get deliveryService => filteredDeliveryServices;

  /// Current delivery services.
  List<DeliveryService> get deliveryServices =>
      List.unmodifiable(_deliveryServices);

  /// Whether delivery services are loading.
  bool get isLoading => _isLoading;

  /// Current error message.
  String? get errorMessage => _errorMessage;

  /// Returns the search query
  String get searchQuery => _searchQuery;

  /// Returns orders filtered by the search query.
  List<DeliveryService> get filteredDeliveryServices {
    if (_searchQuery.isEmpty) {
      return _deliveryServices;
    }

    return _deliveryServices.where((order) {
      final orderId = order.id?.toString() ?? '';

      return orderId.contains(_searchQuery);
    }).toList();
  }

  /// Updates the order search query.
  void searchDeliveryServices(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  /// Loads all delivery services.
  Future<void> loadDeliveryServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _deliveryServices = await _useCase.getDeliveryServices();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a delivery service.
  Future<bool> deleteDeliveryService(int id) async {
    try {
      await _useCase.deleteDeliveryService(id);
      _deliveryServices.removeWhere((deliveryService) =>
      deliveryService.id == id);
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}