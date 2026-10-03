import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/route_result.dart';

/// Provides route calculation using OSRM.
class RoutingService {

  /// An [http.Client] can be provided for making HTTP requests.
  /// If no client is provided, a new [http.Client] is created.
  RoutingService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Client used to communicate with the OSRM API.
  final http.Client _client;

  /// The [driving] endpoint calculates routes for vehicles.
  static const String _baseUrl =
      'https://router.project-osrm.org/route/v1/driving';

  /// Returns a [RouteResult] containing the route distance
  /// and the coordinates that form the route.
  Future<RouteResult> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {

    /// Creates the starting coordinate in the format required by OSRM.
    final start = '$startLongitude,$startLatitude';

    /// Creates the ending coordinate in the format required by OSRM.
    final end = '$endLongitude,$endLatitude';

    /// Creates the URL used to request the route from OSRM.
    final url = Uri.parse(
      '$_baseUrl/$start;$end?overview=full&geometries=geojson',
    );

    /// Sends a GET request to the OSRM API.
    final response = await _client.get(url);

    /// Checks whether the request was successful.
    if (response.statusCode != 200) {
      throw Exception('Failed to calculate route.');
    }

    /// Converts the JSON response from OSRM into a Dart map.
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    /// Retrieves the first route returned by OSRM.
    final route = data['routes'][0] as Map<String, dynamic>;

    /// Retrieves the route distance in meters.
    final distance = (route['distance'] as num).toDouble();

    /// Retrieves the geometry containing the route coordinates.
    final geometry = route['geometry'] as Map<String, dynamic>;

    /// Retrieves the list of coordinates from the route geometry.
    final coordinates = geometry['coordinates'] as List;

    /// Converts the OSRM coordinates into [RoutePoint] objects.
    final points = coordinates.map((coordinate) {
      return RoutePoint(
        longitude: (coordinate[0] as num).toDouble(),
        latitude: (coordinate[1] as num).toDouble(),
      );
    }).toList();

    /// Returns the calculated route with its distance and points.
    return RouteResult(
      distance: distance,
      points: points,
    );
  }
}