import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim/features/users/data/models/user_preview_model.dart';
import 'package:swim/features/users/data/models/user_model.dart';

abstract interface class UsersRemoteDatasource {
  Future<List<UserPreviewModel>> getUsers();
  Future<UserModel> getUserById(int id);
}

class UsersRemoteDatasourceImpl implements UsersRemoteDatasource {
  final http.Client client;

  UsersRemoteDatasourceImpl(this.client);

  @override
  Future<List<UserPreviewModel>> getUsers() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => UserPreviewModel.fromJson(e)).toList();
    }

    throw Exception('Failed to load users: ${response.statusCode}');
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load user: ${response.statusCode}');
  }
}