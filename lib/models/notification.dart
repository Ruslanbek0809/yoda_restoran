import 'package:json_annotation/json_annotation.dart';
part 'notification.g.dart';

@JsonSerializable(includeIfNull: true)
class Notification {
  Notification({
    this.id,
    this.option,
    this.title,
    this.status,
  });

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'option')
  final String? option;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'status')
  final String? status;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
