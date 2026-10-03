/// Represents an ORSM result
class RouteResult {

  /// Class constructor
  const RouteResult ({
    required this.distance,
    required this.points,
  });

  final double distance;

  final List<RoutePoint> points;
}

/// Represents a Point in the OSRM route
class RoutePoint {

  /// Class constructor
  const RoutePoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;

  final double longitude;
}