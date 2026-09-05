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
      throw ArgumentError('Order ID is required to update an Order');
    }

    /// Gets the Order Items for that order
    final orderItemMaps = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [order.id!],
    );


    final existingOrderItems = orderItemMaps
        .map(OrderItemModel.fromMap).toList();

    /// Order Items that the user wants to keep
    final keptOrderItems = order.orderItems
        .where((orderItem) => orderItem.id != null);

    /// IDs of the Order Items that the user wants to keep
    final keptOrderItemsIds = keptOrderItems
        .map((orderItem) => orderItem.id!).toList();

    /// Order Items that are in the database but no longer in order.orderItems
    final orderItemsToDelete = existingOrderItems
        .where(
          (orderItem) => orderItem.id != null
              && !keptOrderItemsIds.contains(orderItem.id!),
        )
        .toList();

    final newOrderItems = <OrderItem>[];

    try {

      /// Saves the new Order Items in a List
      for (final orderItem in orderItems) {
        for (final keptOrderItemId in keptOrderItemsIds) {
          if (orderItem.id! == keptOrderItemId) {
            continue;
          }

          newOrderItems.add(orderItem);
        }
      }

      /// Updates the database atomically
      await db.transaction((txn) async {
        await txn.update(
          'orders',
          {
            'payment_option': order.paymentOption.name,
            'installments': order.installments,
            'price': order.price,
            'deliveryDate': order.deliveryDate,
            'deliveryServiceId': order.deliveryServiceId,
            'clientId': order.clientId,
            'deliveryDistance': order.deliveryDistance,
            'orderObs': order.orderObs,
            'paymentObs': order.paymentObs,
          },
          where: 'id = ?',
          whereArgs: [order.id!],
        );

        /// Remove deleted images
        for (final orderItem in orderItemsToDelete) {
          await txn.delete(
            'order_items',
            where: 'id = ?',
            whereArgs: [orderItem.id]
          );
        }

        /// Updates the order items
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
              'order_id': newOrderItem.orderId,
              'product_id': newOrderItem.productId,
              'quantity': newOrderItem.quantity,
              'unit_price': newOrderItem.unitPrice,
            }
          );
        }

      });
    } catch (e) {
      throw Exception(e.toString());
    }
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