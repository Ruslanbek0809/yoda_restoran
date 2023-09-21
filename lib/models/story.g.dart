// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as int?,
      name: json['name'] as String?,
      text: json['text'] as String?,
      color: json['color'] as String?,
      durationS: json['durationS'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      file: json['file'] as String?,
      restaurant: json['restaurant'] as int?,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'text': instance.text,
      'color': instance.color,
      'durationS': instance.durationS,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'file': instance.file,
      'restaurant': instance.restaurant,
    };
