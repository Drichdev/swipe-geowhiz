class CountryModel {
  final String name;
  final String capital;
  final int population;
  final double area;
  final String phoneCode;
  final String flag;
  final String region;
  final String language;
  final String countryCode;

  CountryModel({
    required this.name,
    required this.capital,
    required this.population,
    required this.area,
    required this.phoneCode,
    required this.flag,
    required this.region,
    required this.language,
    required this.countryCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] ?? '',
      capital: json['capital'] ?? '',
      population: json['population'] ?? 0,
      area: (json['area'] ?? 0).toDouble(),
      phoneCode: json['phoneCode'] ?? '',
      flag: json['flag'] ?? '',
      region: json['region'] ?? '',
      language: json['language'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }
}