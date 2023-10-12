import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable(includeIfNull: true)
class Story {
  Story({
    this.id,
    this.name,
    this.caption,
    this.captionColor,
    this.backgroundColor,
    this.durationS,
    this.deadline,
    this.createdAt,
    this.updatedAt,
    this.file,
    this.isImage,
    this.restaurant,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'caption')
  final String? caption;

  @JsonKey(name: 'caption_color')
  final String? captionColor;

  @JsonKey(name: 'background_color')
  final String? backgroundColor;

  @JsonKey(name: 'durationS')
  final int? durationS;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'deadline')
  final DateTime? deadline;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'file')
  final String? file;

  @JsonKey(name: 'is_image')
  final bool? isImage;

  @JsonKey(name: 'restaurant')
  final int? restaurant;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
