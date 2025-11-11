class Country {
  final String name;
  final String flag;
  final String region;
  final int population;
  final String capital;
  final String cca2;

  Country({
    required this.name,
    required this.flag,
    required this.region,
    required this.population,
    required this.capital,
    required this.cca2,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: (json['name'] as Map?)?['common'] as String? ?? '',
      flag: (json['flags'] as Map?)?['png'] as String? ?? '',
      region: json['region'] ?? '',
      population: json['population'] ?? 0,
      capital: (json['capital'] is List && (json['capital'] as List).isNotEmpty)
          ? (json['capital'] as List).first.toString()
          : 'No Capital',
      cca2: json['cca2'] ?? '',
    );
  }
}

class CountryDetails {
  final String name;
  final String flag;
  final int population;
  final List<dynamic> capital;
  final String region;
  final String subregion;
  final double area;
  final List<dynamic> timezones;
  final String cca2;

  CountryDetails({
    required this.name,
    required this.flag,
    required this.population,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.timezones,
    required this.cca2,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) {
    return CountryDetails(
      name: (json['name'] as Map?)?['common'] as String? ?? '',
      flag: (json['flags'] as Map?)?['png'] as String? ?? '',
      population: json['population'] ?? 0,
      capital: (json['capital'] is List) ? (json['capital'] as List) : const [],
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      timezones: (json['timezones'] is List) ? (json['timezones'] as List) : const [],
      cca2: json['cca2'] ?? '',
    );
  }
}
