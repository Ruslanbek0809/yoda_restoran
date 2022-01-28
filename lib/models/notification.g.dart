// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['id'] as String?,
      option: json['option'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      selfPickUp: json['selfPickUp'] as bool?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'option': instance.option,
      'title': instance.title,
      'status': instance.status,
      'selfPickUp': instance.selfPickUp,
    };
