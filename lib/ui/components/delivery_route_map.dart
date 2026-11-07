import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/routing/models/route_result.dart';
import '../../../features/clients/domain/entities/client.dart';
import '../../../features/store/domain/entities/store.dart';

/// Displays the driving route between the store and the client.
class DeliveryRouteMap extends StatefulWidget {

  /// Class constructor
  const DeliveryRouteMap({
    required this.store,
    required this.client,
    required this.route,
    super.key,
  });

  /// Store containing the store's address and coordinates.
  final Store store;

  /// Client receiving the delivery.
  final Client client;

  /// Route calculated by the routing service, containing distance and points.
  final RouteResult route;

  /// Creates the mutable state associated with this widget.
  @override
  State<DeliveryRouteMap> createState() => _DeliveryRouteMapState();
}

class _DeliveryRouteMapState extends State<DeliveryRouteMap> {
  /// Controller lets us manipulate the map after it has been created.
  GoogleMapController? _mapController;

  /// Converts the store's latitude and longitude into Google's LatLng format.
  LatLng get _storePosition => LatLng(
    widget.store.latitude,
    widget.store.longitude,
  );

  /// Converts the client's latitude and longitude into Google's LatLng format.
  LatLng get _clientPosition => LatLng(
    widget.client.latitude,
    widget.client.longitude,
  );

  /// Converts the route points into the format Google Maps expects.
  /// These points will be used to draw the line representing the route.
  List<LatLng> get _routePoints => widget.route.points
      .map(
        (point) => LatLng(
      point.latitude,
      point.longitude,
    ),
  )
      .toList();

  /// Runs when Flutter updates this widget with new input data.
  @override
  void didUpdateWidget(covariant DeliveryRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// If the route, store coordinates, or client coordinates changed,
    /// adjust the camera to show the new route.
    if (oldWidget.route != widget.route ||
        oldWidget.client.latitude != widget.client.latitude ||
        oldWidget.client.longitude != widget.client.longitude ||
        oldWidget.store.latitude != widget.store.latitude ||
        oldWidget.store.longitude != widget.store.longitude) {
      _fitRoute();
    }
  }

  /// Called by Google Maps when the map has finished initializing.
  void _onMapCreated(GoogleMapController controller) {

    /// Save the controller so other methods can move the camera.
    _mapController = controller;

    /// Adjust the camera to display the complete route.
    _fitRoute();
  }

  /// Moves and zooms the map so the store, client, and route are visible.
  Future<void> _fitRoute() async {

    /// The map controller is not available before map initialization.
    final controller = _mapController;
    if (controller == null) return;

    /// Combine both endpoints and every point along the route.
    final points = [
      _storePosition,
      ..._routePoints,
      _clientPosition,
    ];

    /// At least two points are needed to calculate the visible area.
    if (points.length < 2) return;

    /// Extract all latitudes and longitudes to find the route's boundaries.
    final latitudes = points.map((point) => point.latitude);
    final longitudes = points.map((point) => point.longitude);

    /// Create a rectangle containing every route point.
    /// Southwest uses the smallest latitude and longitude.
    /// Northeast uses the largest latitude and longitude.
    final bounds = LatLngBounds(
      southwest: LatLng(
        latitudes.reduce((a, b) => a < b ? a : b),
        longitudes.reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        latitudes.reduce((a, b) => a > b ? a : b),
        longitudes.reduce((a, b) => a > b ? a : b),
      ),
    );

    /// If both endpoints have identical coordinates, the bounds have
    /// no area. Zoom directly to that location instead.
    if (bounds.southwest == bounds.northeast) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_storePosition, 15),
      );
      return;
    }

    /// Move and zoom the map to fit the rectangle.
    /// The 48-pixel padding keeps markers away from the screen edges.
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 48),
    );
  }

  /// Release the map controller when this widget is removed.
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /// Round the corners of the map.
      borderRadius: BorderRadius.circular(16),

      child: SizedBox(
        /// Give the map a fixed height inside the delivery form.
        height: 300,

        child: GoogleMap(
          /// Initial camera position before the route is fitted.
          initialCameraPosition: CameraPosition(
            target: _storePosition,
            zoom: 12,
          ),

          /// Save the controller when the map initializes.
          onMapCreated: _onMapCreated,

          /// Add a marker for the store and another for the client.
          markers: {
            Marker(
              markerId: const MarkerId('store'),
              position: _storePosition,
              infoWindow: const InfoWindow(
                title: 'Store',
              ),
            ),
            Marker(
              markerId: const MarkerId('client'),
              position: _clientPosition,
              infoWindow: const InfoWindow(
                title: 'Delivery destination',
              ),
            ),
          },

          /// Draw a line connecting the points returned by the routing
          /// service. A polyline is a sequence of connected coordinates.
          polylines: {
            if (_routePoints.length >= 2)
              Polyline(
                polylineId: const PolylineId('delivery_route'),
                points: _routePoints,

                /// Use the app's primary theme color for the route.
                color: Theme.of(context).colorScheme.primary,

                /// Width is measured in screen pixels.
                width: 5,
              ),
          },

          /// The map does not need to show the user's current location.
          myLocationButtonEnabled: false,

          /// Allow users to zoom with the map's controls.
          zoomControlsEnabled: true,

          /// Hide the extra Google Maps toolbar.
          mapToolbarEnabled: false,

          /// Display the compass when relevant.
          compassEnabled: true,
        ),
      ),
    );
  }
}