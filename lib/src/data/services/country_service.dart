import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class CountriesService {
  Future<List<dynamic>> fetchCountries() async {
    final url = Uri.parse(
      'https://restcountries.com/v3.1/all?fields=name,flags,population,region,capital,cca2'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  Future<CountryDetails> fetchCountryDetails(String cca2) async {
    final url = Uri.parse(
        'https://restcountries.com/v3.1/alpha/$cca2?fields=name,flags,population,capital,region,subregion,area,timezones,cca2'
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      // API can return a List with one element, or in edge cases, a Map (error/info).
      if (decoded is List && decoded.isNotEmpty && decoded.first is Map<String, dynamic>) {
        return CountryDetails.fromJson(decoded.first as Map<String, dynamic>);
      } else if (decoded is Map<String, dynamic>) {
        // Some responses come back as a single map; attempt to parse directly.
        return CountryDetails.fromJson(decoded);
      } else {
        throw Exception('Country details not found for $cca2');
      }
    } else {
      throw Exception('Failed to load country details: ${response.statusCode}');
    }
  }
}
