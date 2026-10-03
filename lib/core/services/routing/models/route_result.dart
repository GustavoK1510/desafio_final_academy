/// Represents an ORSM result
class RouteResult {

  /// Class constructor
  const RouteResult ({
    required this.distance,
    required this.points,
  });

  /// Distance
  final double distance;

  /// Points
  final List<RoutePoint> points;
}

/// Represents a Point in the OSRM route
class RoutePoint {

  /// Class constructor
  const RoutePoint({
    required this.latitude,
    required this.longitude,
  });

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;
}