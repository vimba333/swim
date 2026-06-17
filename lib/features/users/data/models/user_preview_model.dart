import 'package:swim/core/domain/entities/user_preview.dart';

class UserPreviewModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  const UserPreviewModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserPreviewModel.fromJson(Map<String, dynamic> json) {
    return UserPreviewModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  UserPreview toEntity() {
    return UserPreview(
      id: id,
      name: name,
      email: email,
      phone: phone,
    );
  }
}