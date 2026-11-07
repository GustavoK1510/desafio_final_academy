import 'package:flutter/foundation.dart';

import '../../../features/clients/domain/entities/client.dart';


/// Provides the client displayed on the details page.
class ClientDetailsProvider extends ChangeNotifier {
  ClientDetailsProvider({
    required this._client,
  });

  final Client _client;

  /// Returns the client being displayed.
  Client get client => _client;
}