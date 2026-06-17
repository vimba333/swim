import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:swim/core/error/app_exception.dart';

abstract interface class SurveyRemoteDatasource {
  Future<void> submitPace(int paceSeconds);
}

class SurveyRemoteDatasourceImpl implements SurveyRemoteDatasource {
  final http.Client client;

  SurveyRemoteDatasourceImpl(this.client);

  @override
  Future<void> submitPace(int paceSeconds) async {

    try {
      final response = await client
          .post(
            Uri.parse('https://jsonplaceholder.typicode.com/posts'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'pace_seconds': paceSeconds}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.statusCode);
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    }
  }
}