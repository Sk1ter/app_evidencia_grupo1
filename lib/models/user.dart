import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String emailOrPhone;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final DateTime birthDate;

  User({
    required this.username,
    required this.emailOrPhone,
    required this.password,
    required this.birthDate,
  });
}
