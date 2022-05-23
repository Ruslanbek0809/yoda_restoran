// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationFromJson(Map<String, dynamic> json) => NotificationModel(
      id: json['id'] as String?,
      option: json['option'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      selfPickUp: json['selfPickUp'] as String?,
    );

Map<String, dynamic> _$NotificationToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'option': instance.option,
      'title': instance.title,
      'status': instance.status,
      'selfPickUp': instance.selfPickUp,
    };
