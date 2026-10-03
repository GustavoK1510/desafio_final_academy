import '../entities/order.dart';
import '../entities/order_item.dart';

/// Represents the contract for [OrderRepository]
abstract class OrderRepository {

  /// Inserts a new [Order] and its [orderItems] into the database
  Future<void> insertOrder(Order order, List<OrderItem> orderItems);

  /// Retrieves all the orders along with their items
  Future<List<Order>> getOrders();

  /// Updates an [Order] and its order items
  Future<void> updateOrder(Order order, List<OrderItem> newOrderItems);

  /// deletes an [Order] and its order items
  Future<void> deleteOrder(int orderId);
}