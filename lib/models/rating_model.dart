import 'package:json_annotation/json_annotation.dart';
part 'rating_model.g.dart';

@JsonSerializable(includeIfNull: true)
class RatingModel {
  RatingModel({
    this.id,
    this.value,
    this.feedback,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'value')
  final double? value;

  @JsonKey(name: 'feedback')
  final String? feedback;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
