import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

class HTTPClient {
  Dio dio = Dio();
  CookieManager cm;
  List<Cookie> cookies = List();

  HTTPClient() {
    dio.interceptors.add(CookieManager(CookieJar()));
    cm = new CookieManager(CookieJar());
  }

  Future<Response> get(String url,
      {Map<String, String> headers = const {}}) async {
    Response resp = await dio.get(url,
        options: Options(
            headers: headers,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }));
    return resp;
  }

  Future<Response> post(String url, dynamic payload) {
    return dio.post(url,
        data: payload,
        options: Options(
            contentType: ContentType.parse('application/x-www-form-urlencoded'),
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }));
  }
}
