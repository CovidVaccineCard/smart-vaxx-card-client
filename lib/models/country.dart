class CountryModel {
  const CountryModel(this.country, this.slug, this.iso2);

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      json['Country'],
      json['Slug'],
      json['ISO2'],
    );
  }
  final String country;
  final String slug;
  final String iso2;
}
