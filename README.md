A library for Dart developers who's in need of [LumiNUS](https://luminus.nus.edu.sg/) API.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

Naming courtesy to https://github.com/indocomsoft/fluminus

## Usage

A simple usage example:

```dart
import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;

main(List<String> args) async {
  // Remember to load the env var for the main() of your own application!
  load();
  Future<Authentication> auth = Future.delayed(
      Duration(seconds: 3),
      () => Authentication(
          password: env['LUMINUS_PASSWORD'],
          username: env['LUMINUS_USERNAME']));
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
}

```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/fluminus/luminus_api/issues
