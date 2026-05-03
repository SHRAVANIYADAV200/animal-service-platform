import '../services/api_service.dart';

class LookupService {
  static final LookupService _instance = LookupService._internal();
  factory LookupService() => _instance;
  LookupService._internal();

  List<String> species = [];
  List<String> vaccines = [];
  List<String> services = [];
  List<String> districts = [];

  bool isLoaded = false;

  Future<void> initialize() async {
    final results = await Future.wait([
      ApiService.getSpecies(),
      ApiService.getVaccines(),
      ApiService.getServiceTypes(),
      ApiService.getDistricts(),
    ]);

    species = results[0];
    vaccines = results[1];
    services = results[2];
    districts = results[3];
    isLoaded = true;
  }
}

// Global instance for easy access
final lookup = LookupService();
