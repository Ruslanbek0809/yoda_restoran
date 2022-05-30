import 'package:json_annotation/json_annotation.dart';
part 'notification_model.g.dart';

@JsonSerializable(includeIfNull: true)
class NotificationModel {
  NotificationModel({
    this.id,
    this.resId,
    this.option,
    this.title,
    this.status,
    this.selfPickUp,
  });

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'resId')
  final String? resId;

  @JsonKey(name: 'option')
  final String? option;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'selfPickUp')
  final String? selfPickUp;


  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
