import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:convert/convert.dart' as conv;
import 'package:html/parser.dart' as parser;
import 'package:luminus_api/src/http_client.dart';
import 'package:meta/meta.dart';

class Authorization {
  /// [idsrv] is the Cookie used for JWT renewal, which is valid for 24 hours.
  String idsrv;

  /// [jwt] is only valid for 1 hour.
  String jwt;
  DateTime idsrvLastUpdated;
  DateTime jwtLastUpdated;

  // Authorization({@required idsrv, this.jwt, this.idsrvLastUpdated, this.jwtLastUpdated});
  Authorization(
      {@required this.idsrv,
      @required this.jwt,
      @required this.idsrvLastUpdated,
      @required this.jwtLastUpdated});

  @override
  String toString() {
    return 'Authorization: ' +
        '{idsrv (last updated at ${this.idsrvLastUpdated.toUtc().toString()}):\n${this.idsrv}; ' +
        'jwt (last updated at ${this.jwtLastUpdated.toUtc().toString()}):\n${this.jwt};}';
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
  static final Duration _jwtExpiresIn = const Duration(minutes: 10);
  static final Duration _refreshTokenExpiresIn = const Duration(hours: 1);

  static HTTPClient client = new HTTPClient();

  Authorization jwt;

  String username;
  String password;
  Authentication({this.username, this.password});

  Future<Authorization> getAuth() async {
    if (jwt != null) {
      if (!_isJwtExpired(jwt)) {
        // print('jwt is not expired');
      } else if (!_isCookieExpired(jwt)) {
        // print('jwt is expired but renewed from cookie');
        jwt = await _renewJwt(jwt);
      } else {
        // print('request for new jwt');
        jwt = await _getJwt(this.username, this.password);
      }
    } else {
      // print('request for new jwt');
      jwt = await _getJwt(this.username, this.password);
    }
    return jwt;
  }

  Future<Authorization> forcedRefresh() async {
    jwt = await _getJwt(this.username, this.password);
    return jwt;
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
    List<Cookie> cookies = List();
    cookies = client.cm.cookieJar.loadForRequest(Uri.parse(loc1));
    var location = t2.headers.value('location');
    String idsrv;
    for (var c in cookies) {
      if (c.name == 'idsrv') {
        idsrv = c.value;
        break;
      }
    }
    if (idsrv == null) throw Exception(['idsrv field is empty']);
    // TODO: time information can be extracted from headers
    return Authorization(
        idsrv: idsrv,
        jwt: _handleCallback(location),
        idsrvLastUpdated: DateTime.now(),
        jwtLastUpdated: DateTime.now());
  }

  static Future<Authorization> _renewJwt(Authorization auth) async {
    String authEndpointUri = await _getAuthEndpointUri();
    var authResponse = await client
        .get(authEndpointUri, cookies: [Cookie('idsrv', auth.idsrv)]);
    var location = authResponse.headers.value('location');
    // TODO: time information can be extracted from headers
    return Authorization(
        idsrv: auth.idsrv,
        jwt: _handleCallback(location),
        idsrvLastUpdated: auth.idsrvLastUpdated,
        jwtLastUpdated: DateTime.now());
  }

  static bool _isCookieExpired(Authorization auth) {
    return DateTime.now()
            .difference(auth.idsrvLastUpdated)
            .compareTo(_refreshTokenExpiresIn) >
        0;
  }

  static bool _isJwtExpired(Authorization auth) {
    return DateTime.now()
            .difference(auth.jwtLastUpdated)
            .compareTo(_jwtExpiresIn) >
        0;
  }

  static String _handleCallback(String location) {
    var parsed = Uri.parse(location);
    if (parsed.hasFragment) {
      // TODO: there should be better ways of parsing the fragment...
      var dummy = Uri.parse('https://dummy.com?' + parsed.fragment);
      // print('_handleCallback: ');
      // print(dummy.queryParameters);
      var token = dummy.queryParameters['id_token'];
      return token;
    } else {
      throw Exception(['Callback format is invalid']);
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
      throw Exception(['Failed to get auth login info: ' + e.toString()]);
    }
  }

  // Generate crypto random bytes in Dart:
  // https://www.scottbrady91.com/Dart/Generating-a-Crypto-Random-String-in-Dart

  static String _generateCryptoRandomString({int length = 32}) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return conv.hex.encode(values);
  }


  static Future<String> _getAuthEndpointUri() async {
    String fullUri = _getFullAuthUri(DISCOVERY_PATH);
    var response = await client.get(fullUri);
    if (response.statusCode == 200) {
      String endpoint = response.data['authorization_endpoint'];
      return _getAuthEndpointUriWithParams(endpoint);
    } else {
      throw Exception([
        'Failed to get full auth URI with status code: ' +
            response.statusCode.toString()
      ]);
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

// Testing functions
void testRenewJwt(Authentication auth) async {
  Authorization autho = await auth.getAuth();
  await new Future.delayed(const Duration(seconds: 5));
  print(await Authentication._renewJwt(autho));
}
