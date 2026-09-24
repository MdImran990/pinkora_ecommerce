import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// What the Home header currently shows, and what tapping it should do.
enum LocationStatus {
  /// Still looking up the location.
  loading,

  /// Area name is ready.
  found,

  /// Location service (GPS) is turned off on the device.
  serviceDisabled,

  /// The user denied the permission (tapping asks again).
  denied,

  /// The user denied it permanently (tapping opens app settings).
  deniedForever,

  /// Something else failed (e.g. no internet for the address lookup).
  error,
}

/// Detects the device's current location and turns it into a readable
/// "Area, City" label for the Home screen header.
///
/// Registered as permanent (see main.dart) and asks for the location
/// permission once, automatically, the first time the app opens - this is
/// what shows the system permission dialog to every user.
class LocationController extends GetxController {
  final Rx<LocationStatus> status = LocationStatus.loading.obs;
  final RxString label = 'Detecting location...'.obs;

  @override
  void onInit() {
    super.onInit();
    detectLocation();
  }

  /// Also called when the user taps the header to retry / open settings.
  Future<void> detectLocation() async {
    status.value = LocationStatus.loading;
    label.value = 'Detecting location...';

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        status.value = LocationStatus.serviceDisabled;
        label.value = 'Turn on location';
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // This is the system dialog every user sees the first time.
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        status.value = LocationStatus.denied;
        label.value = 'Enable location';
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        status.value = LocationStatus.deniedForever;
        label.value = 'Enable location';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final resolved = await _resolveAddress(
        position.latitude,
        position.longitude,
      );

      status.value = LocationStatus.found;
      label.value = resolved;
    } catch (_) {
      status.value = LocationStatus.error;
      label.value = 'Set location';
    }
  }

  Future<String> _resolveAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) return 'Current location';

      final place = placemarks.first;

      // Prefer the neighbourhood/area name, then fall back to the city.
      final area = [place.subLocality, place.locality]
          .firstWhere((e) => e != null && e.isNotEmpty, orElse: () => null);

      final city = [place.locality, place.administrativeArea]
          .firstWhere((e) => e != null && e.isNotEmpty, orElse: () => null);

      if (area != null && city != null && area != city) {
        return '$area, $city';
      }

      return area ?? city ?? 'Current location';
    } catch (_) {
      // No internet, or the platform's address lookup failed - the GPS
      // coordinates were still found, so say so instead of showing an error.
      return 'Current location';
    }
  }

  /// Called when the header is tapped.
  Future<void> handleTap() async {
    switch (status.value) {
      case LocationStatus.serviceDisabled:
        await Geolocator.openLocationSettings();
        break;
      case LocationStatus.deniedForever:
        await Geolocator.openAppSettings();
        break;
      default:
        await detectLocation();
    }
  }
}
