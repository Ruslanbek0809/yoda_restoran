// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
      id: json['id'] as int?,
      value: (json['value'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'feedback': instance.feedback,
    };
