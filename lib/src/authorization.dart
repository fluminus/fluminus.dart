import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart' as conv;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:luminus_api/src/http_client.dart';

class Authorization {
  String idsrv;
  String jwt;
  Authorization({this.idsrv, this.jwt});

  @override
  String toString() {
    return 'Authorization: {idsrv: ${this.idsrv}; jwt: ${this.jwt}}';
  }
}

class Authentication {
  static final Random _random = Random.secure();
  static final String AUTH_BASE_URL = 'https://luminus.nus.edu.sg';
  static final String DISCOVERY_PATH =
      '/v2/auth/.well-known/openid-configuration';
  static final String CLIENT_ID = 'verso';
  static final String SCOPE =
      'profile email role openid lms.read calendar.read lms.delete lms.write calendar.write gradebook.write offline_access';
  static final String RESPONSE_TYPE = 'id_token token code';
  static final String REDIRECT_URI = 'https://luminus.nus.edu.sg/auth/callback';

  static HTTPClient client = new HTTPClient();

  Authorization jwt;

  String username;
  String password;
  Authentication({this.username, this.password});

  Future<Authorization> getAuth() async {
    // TODO: add expiry time check
    if (jwt != null) {
      return jwt;
    } else {
      jwt = await _getJwt(this.username, this.password);
      return jwt;
    }
  }

  static Future<Authorization> _getJwt(String username, String password) async {
    var info = await _getAuthLoginInfo();
    var query = {
      info['xsrf_name']: info['xsrf_value'],
      'username': username,
      'password': password
    };
    var t1 = await client.post(info['fullLoginUri'], query);
    var loc1 = t1.headers.value('location');
    var t2 = await client.get(loc1);
    // For the use of 'idsrv' field later, don't know how to avoid a second request, will figure out later.
    client.cookies = client.cm.cookieJar.loadForRequest(Uri.parse(loc1));
    var location = t2.headers.value('location');
    String idsrv;
    for (var c in client.cookies) {
      if (c.name == 'idsrv') {
        idsrv = c.value;
        break;
      }
    }
    if (idsrv == null) throw Error();
    return Authorization(idsrv: idsrv, jwt: _handleCallback(location));
  }

  static String _handleCallback(String location) {
    var parsed = Uri.parse(location);
    if (parsed.hasFragment) {
      var dummy = Uri.parse('https://dummy.com?' + parsed.fragment);
      var token = dummy.queryParameters['id_token'];
      return token;
    } else {
      throw Error();
    }
  }

  static Future<Map<String, String>> _getAuthLoginInfo() async {
    try {
      Map<String, String> map = new Map();
      String authUri = await _getAuthEndpointUri();
      var resp = await client.get(authUri);
      var headers = resp.headers;
      var location = headers.value('location');
      var body = await client.get(location);
      var document = parser.parse(body.data);
      var modelJson = document
          .getElementById('modelJson')
          .innerHtml
          .replaceAll('&quot;', '"');
      var parsed = jsonDecode(modelJson);
      var fullLoginUri = _getFullAuthUri(parsed['loginUrl']);
      map['fullLoginUri'] = fullLoginUri;
      map['xsrf_name'] = parsed['antiForgery']['name'];
      map['xsrf_value'] = parsed['antiForgery']['value'];
      return map;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Generate crypto random bytes in Dart:
  // https://www.scottbrady91.com/Dart/Generating-a-Crypto-Random-String-in-Dart

  static String _generateCryptoRandomString({int length = 32}) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return conv.hex.encode(values);
  }

  static Future<String> _getAuthEndpointUri() async {
    String fullUri = _getFullAuthUri(DISCOVERY_PATH);
    var response = await http.get(fullUri).catchError((err) {
      // TODO: handle error properly
      print(err);
    });
    if (response.statusCode == 200) {
      String endpoint = jsonDecode(response.body)['authorization_endpoint'];
      return _getAuthEndpointUriWithParams(endpoint);
    } else {
      // TODO: handle error properly
      throw Error();
    }
  }

  static String _getFullAuthUri(String path) {
    return AUTH_BASE_URL + path;
  }

  static String _getAuthEndpointUriWithParams(String uri) {
    String state = _generateCryptoRandomString(length: 16);
    String nonce = _generateCryptoRandomString(length: 16);
    var query = {
      'state': state,
      'nonce': nonce,
      'client_id': CLIENT_ID,
      'scope': SCOPE,
      'response_type': RESPONSE_TYPE,
      'redirect_uri': REDIRECT_URI
    };

    return '${uri}?${Authentication._encodeQuery(query)}'
        .replaceAll(' ', '%20');
  }

  static String _encodeQuery(Map<String, String> query) {
    List<String> keys = query.keys.toList();
    List<String> values = query.values.toList();
    String res = '';
    for (int i = 0; i < keys.length; i++) {
      if (i != 0) {
        res += '&${keys[i]}=${values[i]}';
      } else {
        res += '${keys[i]}=${values[i]}';
      }
    }
    return res;
  }
}
