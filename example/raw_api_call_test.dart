import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;

main(List<String> args) async {
  load();
  Future<Authentication> auth = Future.delayed(Duration(seconds: 3), () => Authentication(
      password: env['LUMINUS_PASSWORD'], username: env['LUMINUS_USERNAME']));

  await Future.delayed(const Duration(seconds: 5));
}
