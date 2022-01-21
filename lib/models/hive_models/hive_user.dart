import 'package:hive/hive.dart';

part 'hive_user.g.dart';

@HiveType(typeId: 3)
class HiveUser {
  HiveUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.gender,
    this.birthday,
    this.accessToken,
    this.favs,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? mobile;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final DateTime? birthday;

  @HiveField(7)
  final String? accessToken;

  @HiveField(8)
  final List<int>? favs;
}
