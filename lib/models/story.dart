import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable(includeIfNull: true)
class Story {
  Story({
    this.id,
    this.name,
    this.text,
    this.color,
    this.durationS,
    this.createdAt,
    this.updatedAt,
    this.file,
    this.restaurant,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'text')
  final String? text;

  @JsonKey(name: 'color')
  final String? color;

  @JsonKey(name: 'durationS')
  final int? durationS;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'file')
  final String? file;

  @JsonKey(name: 'restaurant')
  final int? restaurant;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
