import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:swim/core/error/app_exception.dart';
import 'package:swim/features/users/data/models/user_model.dart';
import 'package:swim/features/users/data/models/user_preview_model.dart';

abstract interface class UsersRemoteDatasource {
  Future<List<UserPreviewModel>> getUsers();
  Future<UserModel> getUserById(int id);
}

class UsersRemoteDatasourceImpl implements UsersRemoteDatasource {
  final http.Client client;

  UsersRemoteDatasourceImpl(this.client);

  @override
  Future<List<UserPreviewModel>> getUsers() async {
    try {
      final response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => UserPreviewModel.fromJson(e)).toList();
      }

      throw ServerException(response.statusCode);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }

      throw ServerException(response.statusCode);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    }
  }
}