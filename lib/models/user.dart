import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.gender,
    this.birthday,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'mobile')
  final String? mobile;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'birthday')
  final String? birthday;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
