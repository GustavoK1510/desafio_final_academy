import 'package:flutter/foundation.dart';

import '../../../features/delivery_services/domain/entities/delivery_service.dart';

/// Provides the delivery service displayed on the details page.
class DeliveryServiceDetailsProvider extends ChangeNotifier {
  DeliveryServiceDetailsProvider({
    required this._deliveryService,
  });

  final DeliveryService _deliveryService;

  /// Returns the delivery service being displayed.
  DeliveryService get deliveryService => _deliveryService;
}