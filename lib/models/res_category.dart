import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'res_category.g.dart';

@JsonSerializable()
class ResCategory {
  ResCategory({
    this.id,
    this.discount,
    this.dateBegin,
    this.dateEnd,
    this.order,
    this.restaurantId,
    this.categoryId,
    this.meals,
    this.resCategoryModel,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'discount')
  final num? discount;

  @JsonKey(name: 'date_begin')
  final DateTime? dateBegin;

  @JsonKey(name: 'date_end')
  final DateTime? dateEnd;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'restaurant')
  final int? restaurantId;

  @JsonKey(name: 'category')
  final int? categoryId;

  @JsonKey(name: 'categoryJson')
  final ResCategoryModel? resCategoryModel;

  @JsonKey(name: 'meal')
  final List<Meal>? meals;

  factory ResCategory.fromJson(Map<String, dynamic> json) =>
      _$ResCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ResCategoryToJson(this);
}
