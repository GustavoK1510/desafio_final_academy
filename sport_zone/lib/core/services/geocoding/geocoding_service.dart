import 'package:geocoding/geocoding.dart';

/// Provides geocoding operations
class GeocodingService {

  /// Converts an address into geographic coordinates.
  Future<Location> getCoordinates({
    required String street,
    required String number,
    required String city,
    required String state,
  }) async {
    final address = '$street, $number, $city, $state';

    final locations = await locationFromAddress(address);

    if (locations.isEmpty) {
      throw Exception(
        'No coordinates were found for the provided address.',
      );
    }

    return locations.first;
  }

  /// Converts geographic coordinates into an address.
  Future<List<Placemark>> getAddress({
    required double latitude,
    required double longitude,
  }) async {
    return placemarkFromCoordinates(
      latitude,
      longitude,
    );
  }
}