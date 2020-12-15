import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:application/Models/User.dart';
import 'package:dio/dio.dart';

class HttpHelper {
  HttpHelper(this.user);
  final User user;
  String cookie;

  Future<Response> getRequest(String requestUrl, bool auth) async {
    Dio dio = new Dio();
    if (auth) {
      dio.options.headers = {
        HttpHeaders.authorizationHeader: "Basic " + user.authenticationString(),
      };
    }

    return await dio.get(requestUrl);
  }

  Future<Response> putRequest(
      String requestUrl, Map<String, dynamic> toSend) async {
    Dio dio = new Dio();
    dio.options.headers = {
      HttpHeaders.authorizationHeader: "Basic " + user.authenticationString(),
    };
    return await dio.put(requestUrl, data: jsonEncode(toSend));
  }

  Future<Response> postRequest(
      String requestUrl, Map<String, dynamic> toSend) async {
    Dio dio = new Dio();
    dio.options.headers = {
      HttpHeaders.authorizationHeader: "Basic " + user.authenticationString(),
    };
    return await dio.post(requestUrl, data: jsonEncode(toSend));
  }

  Future<Response> authorize(String requestUrl) async {
    var client = Dio(BaseOptions(
      baseUrl: requestUrl,
      connectTimeout: 5000,
      receiveTimeout: 10000,
      headers: {
        HttpHeaders.authorizationHeader: "Basic " + user.authenticationString(),
      },
    ));
    Response response = await client.get(requestUrl);
    cookie = response.headers["Set-Cookie"].toString();
    return response;
  }

  Future<void> deauth() async {
    Dio dio = Dio();
    dio.options.headers = {
      HttpHeaders.authorizationHeader: "Basic " + user.authenticationString(),
      "Content-Type": "application/json",
    };
    dio.get('https://localhost:9090/logout');
    cookie = "";
  }
}
