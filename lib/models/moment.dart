import 'package:json_annotation/json_annotation.dart';
import 'package:yoda_res/models/story.dart';

import 'models.dart';

part 'moment.g.dart';

@JsonSerializable(includeIfNull: true)
class Moment {
  Moment({
    this.id,
    this.restaurant,
    this.stories,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'restaurant')
  final Restaurant? restaurant;

  @JsonKey(name: 'stories')
  final List<Story>? stories;

  factory Moment.fromJson(Map<String, dynamic> json) => _$MomentFromJson(json);

  Map<String, dynamic> toJson() => _$MomentToJson(this);
}
