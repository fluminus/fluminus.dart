import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;

main(List<String> args) async {
  load();
  Authentication auth = new Authentication(
      password: env['LUMINUS_PASSWORD'], username: env['LUMINUS_USERNAME']);
  Authorization autho = await auth.getAuth();
  await Future.delayed(const Duration(seconds: 5));
  await auth.getAuth();
}
