import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'dart:io' as io;

main(List<String> args) async {
  // Remember to load the env var for the main() of your own application!
  load();
  Authentication auth = new Authentication(
      password: env['LUMINUS_PASSWORD'], username: env['LUMINUS_USERNAME']);
  var modules = await API.getModules(auth);
  for (Module mod in modules) {
    print(mod.courseName);
    print(mod.id);
    print(await API.getAnnouncements(auth, mod));
    var dirs = await API.getModuleDirectories(auth, mod);
    for (var dir in dirs) {
      var items = await API.getItemsFromDirectory(auth, dir);
      print(items);
      for (var item in items) {
        if (item is File) {
          print(await API.getDownloadUrl(auth, item));
        }
      }
    }
  }
  print(await API.getProfile(auth));
  // var res = io.File('./res');
  // var sink = res.openWrite();
  // sink.write(await API.getActiveAnnouncements(auth));
  // await sink.flush();
  // await sink.close();
  
}
