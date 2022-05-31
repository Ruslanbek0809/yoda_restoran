// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      resId: json['resId'] as String?,
      option: json['option'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      selfPickUp: json['selfPickUp'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resId': instance.resId,
      'option': instance.option,
      'title': instance.title,
      'status': instance.status,
      'selfPickUp': instance.selfPickUp,
    };
