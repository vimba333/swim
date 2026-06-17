import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim/features/users/data/models/user_preview_model.dart';

abstract interface class UsersRemoteDatasource {
  Future<List<UserPreviewModel>> getUsers();
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
}