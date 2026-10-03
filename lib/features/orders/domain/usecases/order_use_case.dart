import '../../../../core/services/routing/routing_service.dart';
import '../../../clients/domain/repositories/client_repository.dart';
import '../../../delivery_services/domain/repositories/delivery_service_repository.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../../../store/domain/repositories/store_repository.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../repositories/order_repository.dart';

/// Provides order-related application operations
class OrderUseCase {

  /// Class constructor
  OrderUseCase ({
    required this._orderRepository,
    required this._clientRepository,
    required this._storeRepository,
    required this._deliveryServiceRepository,
    required this._productRepository,
    required this._routingService,
  });

  final OrderRepository _orderRepository;
  final ClientRepository _clientRepository;
  final StoreRepository _storeRepository;
  final DeliveryServiceRepository _deliveryServiceRepository;
  final ProductRepository _productRepository;
  final RoutingService _routingService;

  /// Adds a new [Order]
  Future<void> insertOrder(Order order) async {

    /// Gets the store data
    final store = await _storeRepository.getStore();

    /// Gets the client data
    final client = await _clientRepository.getClient(order.clientId);

    /// Calculates the route between them
    final route  = await _routingService.getRoute(
      startLatitude: store!.latitude,
      startLongitude: store.longitude,
      endLatitude: client.latitude,
      endLongitude: client.longitude,
    );

    /// Calculates the distance in kilometers
    final distanceKm = route.distance/1000;

    /// Gets the delivery service data
    final deliveryService = await _deliveryServiceRepository
        .getDeliveryService(order.deliveryServiceId);

    /// Calculates the delivery price
    var deliveryPrice = distanceKm * deliveryService.kmCost;

    /// Verifies if it is higher than the minimum price, if there is one
    if (deliveryService.minimumPrice != null &&
        deliveryPrice < deliveryService.minimumPrice!) {
      deliveryPrice = deliveryService.minimumPrice!;
    }

    var productsPrice = 0.0;

    final orderItems = <OrderItem>[];

    for (final item in order.orderItems) {

      /// Gets each product data
      final product = await _productRepository.getProduct(item.productId);

      /// Calculates the total products price
      productsPrice += product.price * item.quantity;

      /// Adds each item to the item list
      orderItems.add(
        OrderItem(
          orderId: item.orderId,
          productId: item.productId,
          quantity: item.quantity,
          unitPrice: product.price,
        )
      );
    }

    /// Calculates the total price
    final totalPrice = productsPrice + deliveryPrice;

    /// Creates an Order with the values
    final orderWithValues = Order(
      id: order.id,
      paymentOption: order.paymentOption,
      installments: order.installments,
      price: totalPrice,
      deliveryDate: order.deliveryDate,
      deliveryServiceId: order.deliveryServiceId,
      clientId: order.clientId,
      deliveryDistance: distanceKm,
      deliveryPrice: deliveryPrice,
      orderObs: order.orderObs,
      paymentObs: order.paymentObs,
      orderItems: orderItems,
    );

    /// Sends it to the repository
    await _orderRepository.insertOrder(orderWithValues, orderItems);
  }

  /// Retrieves all the Orders
  Future<List<Order>> getOrders() async {
    final orders = await _orderRepository.getOrders();

    return orders;
  }

  /// Updates an Order
  Future<void> updateOrder(Order order) async {

    /// Gets the store data
    final store = await _storeRepository.getStore();

    /// Gets the client data
    final client = await _clientRepository.getClient(order.clientId);

    /// Calculates the route between them
    final route  = await _routingService.getRoute(
      startLatitude: store!.latitude,
      startLongitude: store.longitude,
      endLatitude: client.latitude,
      endLongitude: client.longitude,
    );

    /// Calculates the distance in kilometers
    final distanceKm = route.distance/1000;

    /// Gets the delivery service data
    final deliveryService = await _deliveryServiceRepository
        .getDeliveryService(order.deliveryServiceId);

    /// Calculates the delivery price
    var deliveryPrice = distanceKm * deliveryService.kmCost;

    /// Verifies if it is higher than the minimum price, if there is one
    if (deliveryService.minimumPrice != null &&
        deliveryPrice < deliveryService.minimumPrice!) {
      deliveryPrice = deliveryService.minimumPrice!;
    }

    var productsPrice = 0.0;

    final orderItems = <OrderItem>[];

    for (final item in order.orderItems) {

      /// Gets each product data
      final product = await _productRepository.getProduct(item.productId);

      /// Gets the unit price
      final unitPrice = product.price;

      /// Calculates the total products price
      productsPrice += unitPrice * item.quantity;

      /// Adds each item to the item list
      orderItems.add(
          OrderItem(
            id: item.id,
            orderId: item.orderId,
            productId: item.productId,
            quantity: item.quantity,
            unitPrice: unitPrice,
          )
      );
    }

    /// Calculates the total price
    final totalPrice = productsPrice + deliveryPrice;

    /// Creates an Order with the values
    final orderWithValues = Order(
      id: order.id,
      paymentOption: order.paymentOption,
      installments: order.installments,
      price: totalPrice,
      deliveryDate: order.deliveryDate,
      deliveryServiceId: order.deliveryServiceId,
      clientId: order.clientId,
      deliveryDistance: distanceKm,
      deliveryPrice: deliveryPrice,
      orderObs: order.orderObs,
      paymentObs: order.paymentObs,
      orderItems: orderItems,
    );

    /// Sends it to the repository
    await _orderRepository.updateOrder(orderWithValues, orderItems);
  }

  /// Deletes an Order by it's ID
  Future<void> deleteOrder(int orderId) async {
    await _orderRepository.deleteOrder(orderId);
  }
}