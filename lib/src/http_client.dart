import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:luminus_api/src/exception.dart';

class HTTPClient {
  Dio dio = Dio();
  CookieManager cm;

  HTTPClient() {
    dio.interceptors.add(CookieManager(CookieJar()));
    cm = new CookieManager(CookieJar());
  }

  static void _catchHttpExceptions(Response resp, String place) {
    switch (resp.statusCode) {
      case 400:
        throw BadRequestException(place);
      case 403:
        throw ForbiddenException(place);
      case 404:
        throw NotFoundException(place);
      case 500:
        throw InternalServerErrorException(place);
      default:
        return;
    }
  }

  int _connectTimeOut = 500;
  int _receiveTimeOut = 1000;
  int _sendTimeOut = 500;

  Future<Response> get(String url,
      {Map<String, String> headers = const {},
      Iterable<Cookie> cookies = const []}) async {
    Response resp = await dio.get(url,
        options: Options(
            connectTimeout: _connectTimeOut,
            receiveTimeout: _receiveTimeOut,
            sendTimeout: _sendTimeOut,
            headers: headers,
            cookies: cookies,
            followRedirects: false,
            validateStatus: (status) {
              // 500 would be caught later,
              // this is for the sake of exception consistency.
              return status <= 500;
            }));
    _catchHttpExceptions(resp, 'HTTPClient.get');
    return resp;
  }

  Future<Response> post(String url, dynamic payload,
      {Map<String, dynamic> headers}) async {
    Response resp = await dio.post(url,
        data: payload,
        options: Options(
            headers: headers,
            connectTimeout: _connectTimeOut,
            receiveTimeout: _receiveTimeOut,
            sendTimeout: _sendTimeOut,
            contentType: ContentType.parse('application/x-www-form-urlencoded'),
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }));
    _catchHttpExceptions(resp, 'HTTPClient.post');
    return resp;
  }
}
