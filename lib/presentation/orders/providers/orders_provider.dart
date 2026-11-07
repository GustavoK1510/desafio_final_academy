import 'package:flutter/material.dart';

import '../../../core/services/order_receipt/order_receipt_pdf_service.dart';
import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../../features/orders/domain/entities/order.dart';
import '../../../features/orders/domain/usecases/order_use_case.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../features/store/domain/usecases/store_use_case.dart';

/// Manages order listing, searching, deletion and PDF generation.
class OrdersProvider extends ChangeNotifier {

  /// Class constructor
  OrdersProvider({
    required this._orderUseCase,
    required this._clientUseCase,
    required this._deliveryServiceUseCase,
    required this._productUseCase,
    required this._storeUseCase,
    required this._pdfService,
  });

  final OrderUseCase _orderUseCase;
  final UseCaseClient _clientUseCase;
  final DeliveryServiceUseCase _deliveryServiceUseCase;
  final ProductUseCase _productUseCase;
  final StoreUseCase _storeUseCase;
  final OrderReceiptPdfService _pdfService;

  List<Order> _orders = [];
  List<Client> _clients = [];
  List<DeliveryService> _deliveryServices = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  /// getter for the filtered orders list
  List<Order> get orders => filteredOrders;

  /// Returns whether is loading
  bool get isLoading => _isLoading;

  /// Returns an error message
  String? get errorMessage => _errorMessage;

  /// Returns the search query
  String get searchQuery => _searchQuery;

  /// Returns orders filtered by the search query.
  List<Order> get filteredOrders {
    if (_searchQuery.isEmpty) {
      return _orders;
    }

    return _orders.where((order) {
      final orderId = order.id?.toString() ?? '';

      return orderId.contains(_searchQuery);
    }).toList();
  }

  /// Loads orders, clients and delivery services.
  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderUseCase.getOrders();
      _clients = await _clientUseCase.getClients();
      _deliveryServices =
      await _deliveryServiceUseCase.getDeliveryServices();
    } catch (error) {
      _errorMessage = 'Failed to load orders: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the order search query.
  void searchOrders(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  /// Returns the client name associated with an order.
  String getClientName(Order order) {
    final clients = _clients.where(
          (client) => client.id == order.clientId,
    );

    if (clients.isEmpty) {
      return 'Unknown client';
    }

    return clients.first.name;
  }

  /// Returns the delivery service name associated with an order.
  String getDeliveryServiceName(Order order) {
    final services = _deliveryServices.where(
          (service) => service.id == order.deliveryServiceId,
    );

    if (services.isEmpty) {
      return 'Unknown delivery service';
    }

    return services.first.name;
  }

  /// Deletes an order and updates the local list.
  Future<void> deleteOrder(int orderId) async {
    try {
      await _orderUseCase.deleteOrder(orderId);

      _orders.removeWhere((order) => order.id == orderId);

      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to delete order: $error';
      notifyListeners();

      rethrow;
    }
  }

  /// Generates a PDF receipt containing the order information.
  Future<void> generateOrderPdf(Order order) async {
    try {
      final clients = _clients.where(
            (client) => client.id == order.clientId,
      );

      if (clients.isEmpty) {
        throw StateError('Client not found.');
      }

      final services = _deliveryServices.where(
            (service) => service.id == order.deliveryServiceId,
      );

      if (services.isEmpty) {
        throw StateError('Delivery service not found.');
      }

      final store = await _storeUseCase.getStore();

      if (store == null) {
        throw StateError('Store information not found.');
      }

      final products = await _productUseCase.getProducts();

      await _pdfService.generate(
        order: order,
        client: clients.first,
        deliveryService: services.first,
        store: store,
        products: products,
      );
    } catch (error) {
      _errorMessage = 'Failed to generate PDF: $error';
      notifyListeners();

      rethrow;
    }
  }
}