import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;

main(List<String> args) async {
  // Remember to load the env var for the main() of your own application!
  load();
  Authentication auth = new Authentication(
      password: env['LUMINUS_PASSWORD'], username: env['LUMINUS_USERNAME']);
  var modules = await API.getModules(auth);
  for (Module mod in modules) {
    print(mod.courseName);
  }
}