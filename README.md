A library for Dart developers who's in need of [LumiNUS](https://luminus.nus.edu.sg/) API.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
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
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/fluminus/luminus_api/issues
