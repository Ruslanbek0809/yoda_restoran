// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as int?,
      name: json['name'] as String?,
      caption: json['caption'] as String?,
      captionColor: json['caption_color'] as String?,
      backgroundColor: json['background_color'] as String?,
      durationS: json['durationS'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      file: json['file'] as String?,
      isImage: json['is_image'] as bool?,
      restaurant: json['restaurant'] as int?,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'caption': instance.caption,
      'caption_color': instance.captionColor,
      'background_color': instance.backgroundColor,
      'durationS': instance.durationS,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'file': instance.file,
      'is_image': instance.isImage,
      'restaurant': instance.restaurant,
    };
