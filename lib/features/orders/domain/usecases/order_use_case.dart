
import '../../../../core/services/routing/routing_service.dart';
import '../../../clients/domain/repositories/client_repository.dart';
import '../../../delivery_services/domain/repositories/delivery_service_repository.dart';
import '../../../store/domain/repositories/store_repository.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../enums/payment_option.dart';
import '../repositories/order_repository.dart';

/// Provides order-related application operations.
class OrderUseCase {

  /// Class constructor.
  OrderUseCase({
    required this._orderRepository,
    required this._clientRepository,
    required this._storeRepository,
    required this._deliveryServiceRepository,
    required this._routingService,
  });

  final OrderRepository _orderRepository;
  final ClientRepository _clientRepository;
  final StoreRepository _storeRepository;
  final DeliveryServiceRepository _deliveryServiceRepository;
  final RoutingService _routingService;

  /// Validates order items and calculates their discounted total.
  Future<double> _calculateProductsPrice(List<OrderItem> items) async {
    if (items.isEmpty) {
      throw StateError('An order must contain at least one item.');
    }

    var productsPrice = 0.0;

    for (final item in items) {
      if (item.quantity <= 0) {
        throw StateError('Product quantity must be greater than zero.');
      }

      if (item.unitPrice < 0) {
        throw StateError('Product unit price cannot be negative.');
      }

      if (item.discount < 0 || item.discount > 100) {
        throw StateError('Product discount must be between 0 and 100.');
      }

      // Calculates the item total after applying its discount.
      final subtotal = item.unitPrice * item.quantity;
      final discountAmount = subtotal * item.discount / 100;

      productsPrice += subtotal - discountAmount;
    }

    return productsPrice;
  }

  /// Calculates the delivery price using the delivery service.
  Future<double> _calculateDeliveryPrice({
    required int clientId,
    required int deliveryServiceId,
  }) async {
    final store = await _storeRepository.getStore();

    if (store == null) {
      throw StateError('Store information was not found.');
    }

    final client = await _clientRepository.getClient(clientId);

    final deliveryService = await _deliveryServiceRepository
        .getDeliveryService(deliveryServiceId);

    // Calculates the route between the store and the client.
    final route = await _routingService.getRoute(
      startLatitude: store.latitude,
      startLongitude: store.longitude,
      endLatitude: client.latitude,
      endLongitude: client.longitude,
    );

    final distance = route.distance;

    // Calculates the delivery price.
    var deliveryPrice = distance * deliveryService.kmCost;

    // Applies the minimum delivery price when necessary.
    if (deliveryService.minimumPrice != null &&
        deliveryPrice < deliveryService.minimumPrice!) {
      deliveryPrice = deliveryService.minimumPrice!;
    }

    return deliveryPrice;
  }

  /// Applies the credit-card surcharge when necessary.
  double _calculateFinalPrice({
    required double productsPrice,
    required double deliveryPrice,
    required Order order,
  }) {
    final subtotal = productsPrice + deliveryPrice;

    if (order.paymentOption == PaymentOption.creditCard) {
      return subtotal * 1.04;
    }

    return subtotal;
  }

  /// Adds a new order.
  Future<void> insertOrder(Order order) async {
    if (order.installments < 1) {
      throw StateError('Installments must be at least one.');
    }

    final deliveryPrice = await _calculateDeliveryPrice(
      clientId: order.clientId,
      deliveryServiceId: order.deliveryServiceId,
    );

    final productsPrice = await _calculateProductsPrice(order.orderItems);

    final totalPrice = _calculateFinalPrice(
      productsPrice: productsPrice,
      deliveryPrice: deliveryPrice,
      order: order,
    );

    final orderWithValues = Order(
      id: order.id,
      paymentOption: order.paymentOption,
      installments: order.installments,
      price: totalPrice,
      deliveryDate: order.deliveryDate,
      deliveryServiceId: order.deliveryServiceId,
      clientId: order.clientId,
      deliveryDistance: order.deliveryDistance,
      deliveryPrice: deliveryPrice,
      orderObs: order.orderObs,
      paymentObs: order.paymentObs,
      orderItems: order.orderItems,
    );

    await _orderRepository.insertOrder(
      orderWithValues,
      order.orderItems,
    );
  }

  /// Retrieves all orders.
  Future<List<Order>> getOrders() async {
    return await _orderRepository.getOrders();
  }

  /// Updates an existing order.
  Future<void> updateOrder(Order order) async {
    if (order.id == null) {
      throw StateError('Cannot update an order without an ID.');
    }

    if (order.installments < 1) {
      throw StateError('Installments must be at least one.');
    }

    final deliveryPrice = await _calculateDeliveryPrice(
      clientId: order.clientId,
      deliveryServiceId: order.deliveryServiceId,
    );

    final productsPrice = await _calculateProductsPrice(order.orderItems);

    final totalPrice = _calculateFinalPrice(
      productsPrice: productsPrice,
      deliveryPrice: deliveryPrice,
      order: order,
    );

    final orderWithValues = Order(
      id: order.id,
      paymentOption: order.paymentOption,
      installments: order.installments,
      price: totalPrice,
      deliveryDate: order.deliveryDate,
      deliveryServiceId: order.deliveryServiceId,
      clientId: order.clientId,
      deliveryDistance: order.deliveryDistance,
      deliveryPrice: deliveryPrice,
      orderObs: order.orderObs,
      paymentObs: order.paymentObs,
      orderItems: order.orderItems,
    );

    await _orderRepository.updateOrder(
      orderWithValues,
      order.orderItems,
    );
  }

  /// Deletes an order by its ID.
  Future<void> deleteOrder(int orderId) async {
    await _orderRepository.deleteOrder(orderId);
  }
}
