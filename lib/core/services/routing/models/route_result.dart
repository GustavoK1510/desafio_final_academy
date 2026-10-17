/// Represents an ORSM result
class RouteResult {

  /// Class constructor
  const RouteResult ({
    required this._distance,
    required this._points,
  });

  final double _distance;
  final List<RoutePoint> _points;

  double get distance => _distance;

  List<RoutePoint> get points => _points;
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