import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  Meal({
    this.id,
    this.image,
    this.name,
    this.description,
    this.approved,
    this.discount,
    this.price,
    this.discountedPrice,
    this.available,
    this.dateBegin,
    this.dateEnd,
    this.value,
    this.restaurantId,
    this.categoryId,
    this.sizeId,
    this.size,
    this.gVolumes,
    this.gCustomizables,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'approved')
  final bool? approved;

  @JsonKey(name: 'discount')
  final int? discount;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'discountedPrice')
  final num? discountedPrice;

  @JsonKey(name: 'available')
  final bool? available;

  @JsonKey(name: 'date_begin')
  final DateTime? dateBegin;

  @JsonKey(name: 'date_end')
  final DateTime? dateEnd;

  @JsonKey(name: 'value')
  final num? value;

  @JsonKey(name: 'restaurant')
  final int? restaurantId;

  @JsonKey(name: 'category')
  final int? categoryId;

  @JsonKey(name: 'size')
  final int? sizeId;

  @JsonKey(name: 'sizeJson')
  final SizeModel? size;

  @JsonKey(name: 'gVolumes')
  final List<MainVolume>? gVolumes;

  @JsonKey(name: 'gCostumizes')
  final List<MainCustomizable>? gCustomizables;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
