import 'package:meta/meta.dart';

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String mobileNumber;
  final String fcmToken;

  UserProfile({
    this.userId,
    this.name,
    this.email,
    this.mobileNumber,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'email': email,
    'mobileNumber': mobileNumber,
    'fcmToken': fcmToken,
  };
}
