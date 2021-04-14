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

  Future<bool> login(String requestUrl, bool auth) async {
    try {
      Response response = await getRequest(requestUrl, auth);
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (exception) {
      if (exception.response.statusCode == 401 ||
          exception.response.statusCode == 403) {
        return false;
      }
    }
    return false;
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
    Response res = await dio.post(requestUrl, data: jsonEncode(toSend));
    if (res.statusCode != 200 || res.statusCode != 201) {
      //Something went  wrong with the request
      return null;
    } else {
      return res;
    }
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
