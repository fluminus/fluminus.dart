import 'dart:convert';

import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;

main(List<String> args) async {
  load();
  Authentication auth = Authentication(
      password: env['LUMINUS_PASSWORD'], username: env['LUMINUS_USERNAME']);
  print(await API.getNotifications(auth, limit: 2));
}
