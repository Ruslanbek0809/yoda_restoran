class Food {
  final int id;
  final String name;
  final num weight;
  final String weightType;
  final num price;
  final String image;
  final List<AdditionalFoodModel> additionals;
  Food(
    this.id,
    this.name,
    this.weight,
    this.weightType,
    this.price,
    this.image,
    this.additionals,
  );
}

class AdditionalFoodModel {
  final String name;
  final num price;
  bool isAdded;
  AdditionalFoodModel(
    this.name,
    this.price,
    this.isAdded,
  );
}
