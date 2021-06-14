/*
* Class to manage Hero data
* */
class HeroModel {
  final String id;
  final String heroName;
  final DateTime bornDate;
  final String citizenship;
  final String domain;
  final String biography;
  final String imageUrl;
  final String addedUserId;

  HeroModel({required this.id, required this.heroName, required this.bornDate, required this.citizenship, required this.domain,
    required this.biography, required this.imageUrl, required this.addedUserId});
}

