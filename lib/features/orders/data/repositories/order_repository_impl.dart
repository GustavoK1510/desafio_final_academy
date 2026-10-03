import 'package:sqflite/sqflite.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';

/// The implementation of [OrderRepository]
class OrderRepositoryImpl implements OrderRepository {

  /// the [Database] instance
  final Database db;

  /// Class constructor
  OrderRepositoryImpl({required this.db});

  @override
  Future<void> insertOrder(Order order, List<OrderItem> orderItems) async {

    /// Creates an OrderModel
    final orderModel = OrderModel(
        paymentOption: order.paymentOption,
        installments: order.installments,
        price: order.price,
        deliveryPrice: order.deliveryPrice,
        deliveryDate: order.deliveryDate,
        deliveryServiceId: order.deliveryServiceId,
        clientId: order.clientId,
        deliveryDistance: order.deliveryDistance,
        orderObs: order.orderObs,
        paymentObs: order.paymentObs,
    );

    /// Inserts the model and its items into the database
    await db.transaction((txn) async {
      final orderId = await txn.insert('orders', orderModel.toMap());

      for (final orderItem in orderItems) {

        await txn.insert('order_items', {
          'order_id': orderId,
          'product_id': orderItem.productId,
          'quantity': orderItem.quantity,
          'unit_price': orderItem.unitPrice,
        });
      }
    });
  }

  @override
  Future<List<Order>> getOrders() async {

    /// Selects the 'orders' table
    final orderMaps = await db.query('orders');

    /// Creates an empty List
    final orders = <Order>[];

    for (final orderMap in orderMaps) {

      /// Retrieves each Order ID
      final orderId = orderMap['id'] as int;

      /// Gets all the items associated with that Order
      final orderItemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
        orderBy: 'id ASC',
      );

      /// Converts the OrderItem Map into an OrderItemModel
      final orderItems = orderItemMaps.map(OrderItemModel.fromMap).toList();

      /// Converts the Order Map into an OrderModel with its items
      final order = OrderModel.fromMap(orderMap, orderItems: orderItems);

      /// Adds the Order to the List
      orders.add(order);
    }

    /// Returns the List
    return orders;
  }

  @override
  Future<void> updateOrder(Order order, List<OrderItem> orderItems) async {

    /// Checks if the Order has an ID
    if (order.id == null) {
      throw ArgumentError(
        'Order ID is required to update an Order',
      );
    }

    /// Gets the Order Items for that order
    final orderItemMaps = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [order.id!],
    );

    /// Converts database maps into OrderItems
    final existingOrderItems = orderItemMaps
        .map(OrderItemModel.fromMap)
        .toList();

    /// Order Items that already exist and must be kept
    final keptOrderItems = orderItems
        .where((orderItem) => orderItem.id != null)
        .toList();

    /// IDs of the Order Items that must be kept
    final keptOrderItemsIds = keptOrderItems
        .map((orderItem) => orderItem.id!)
        .toList();

    /// Order Items that exist in the database but
    /// are no longer present in the updated order
    final orderItemsToDelete = existingOrderItems
        .where(
          (orderItem) => orderItem.id != null &&
          !keptOrderItemsIds.contains(orderItem.id!),
        ).toList();

    /// New Order Items that do not have an ID yet
    final newOrderItems = orderItems
        .where((orderItem) => orderItem.id == null)
        .toList();

    /// Updates the database atomically
    await db.transaction((txn) async {
      /// Updates the Order
      await txn.update(
        'orders',
        {
          'payment_option': order.paymentOption.name,
          'installments': order.installments,
          'price': order.price,
          'delivery_price': order.deliveryPrice,
          'delivery_date': order.deliveryDate.millisecondsSinceEpoch,
          'delivery_service_id': order.deliveryServiceId,
          'client_id': order.clientId,
          'delivery_distance': order.deliveryDistance,
          'order_obs': order.orderObs,
          'payment_obs': order.paymentObs,
        },
        where: 'id = ?',
        whereArgs: [order.id!],
      );

      /// Removes deleted items
      for (final orderItem in orderItemsToDelete) {
        await txn.delete(
          'order_items',
          where: 'id = ?',
          whereArgs: [orderItem.id!],
        );
      }

      /// Updates existing Order Items
      for (final orderItem in keptOrderItems) {
        await txn.update(
          'order_items',
          {
            'product_id': orderItem.productId,
            'quantity': orderItem.quantity,
            'unit_price': orderItem.unitPrice,
          },
          where: 'id = ?',
          whereArgs: [orderItem.id!],
        );
      }

      /// Inserts new Order Items
      for (final newOrderItem in newOrderItems) {
        await txn.insert(
          'order_items',
          {
            'order_id': order.id!,
            'product_id': newOrderItem.productId,
            'quantity': newOrderItem.quantity,
            'unit_price': newOrderItem.unitPrice,
          },
        );
      }
    });
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId]
    );
  }

}