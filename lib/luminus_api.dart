library luminus_api;

export 'src/luminus_api_base.dart';
export 'package:luminus_api/src/module.dart';
export 'package:luminus_api/src/announcement.dart';
export 'package:luminus_api/src/profile.dart';
export 'package:luminus_api/src/file.dart';
export 'package:luminus_api/src/authorization.dart';

import 'package:dotenv/dotenv.dart' show load, env;
import 'package:dio/dio.dart';

import 'src/announcement_response.dart';
import 'src/download_response.dart';
import 'src/file_response.dart';
import 'src/module_response.dart';

import 'package:luminus_api/src/module.dart';
import 'package:luminus_api/src/announcement.dart';
import 'package:luminus_api/src/profile.dart';
import 'package:luminus_api/src/file.dart';
import 'package:luminus_api/src/authorization.dart';

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
}

class API {
  // API access infrastructure

  static final String OCM_APIM_SUBSCRIPTION_KEY =
      '6963c200ca9440de8fa1eede730d8f7e';
  static final String API_BASE_URL = 'https://luminus.azure-api.net';

  static var dio = Dio();

  static Future<Map> _apiGet(Authorization auth, String path,
      {bool isTest = false}) async {
    Map<String, dynamic> headers = Map();
    headers['Authorization'] = 'Bearer ${auth.jwt}';
    headers['Ocp-Apim-Subscription-Key'] = OCM_APIM_SUBSCRIPTION_KEY;
    var uri = API_BASE_URL + path;
    // print('apiGet: '+uri);
    var resp = await dio.get(uri, options: Options(headers: headers));
    return resp.data;
  }

  static Future<Map> _rawAPICall(
      {Authentication auth, String path, bool isTest = false}) async {
    Map parsed = await _apiGet(await auth.getAuth(), path);
    return parsed;
  }

  // Module related APIs

  static Future<List<Module>> getModules(Authentication auth) async {
    Map resp = await _rawAPICall(auth: auth, path: '/module');
    var modules = new ModuleResponse.fromJson(resp);
    return modules.data;
  }

  // Announcement related APIs

  static Future<List<Announcement>> getAnnouncements(
      Authentication auth, Module module,
      {bool archived = false}) async {
    Map resp = await API._rawAPICall(
        auth: auth,
        path:
            "/announcement/${archived ? 'Archived' : 'NonArchived'}/${module.id}?=displayFrom%20ASC");
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  // Personal information related APIs

  static Future<Profile> getProfile(Authentication auth) async {
    Map resp = await API._rawAPICall(auth: auth, path: "/user/profile");
    var profile = new Profile.fromJson(resp);
    return profile;
  }

  // File related APIs

  static Future<List<Directory>> getModuleDirectories(
      Authentication auth, Module module) async {
    Map resp =
        await API._rawAPICall(auth: auth, path: "/files/?ParentID=${module.id}");
    return (new SubdirectoryResponse.fromJson(resp)).data;
  }

  static Future<List<Directory>> getSubdirectories(
      Authentication auth, Directory dir) async {
    Map resp =
        await API._rawAPICall(auth: auth, path: "/files/?ParentID=${dir.id}");
    return (new SubdirectoryResponse.fromJson(resp)).data;
  }

  static Future<List<BasicFile>> getItemsFromDirectory(
      Authentication auth, Directory dir) async {
    // Get the subdirectories
    var fileResp = FileResponse.fromJson(await API._rawAPICall(
        auth: auth,
        path:
            "/files/${dir.id}/file${dir.allowUpload ? '?populate=Creator' : ''}"));
    var dirResp = SubdirectoryResponse.fromJson(
        await API._rawAPICall(auth: auth, path: "/files/?ParentID=${dir.id}"));
    List<BasicFile> list = new List();
    if (fileResp != null) list.addAll(fileResp.data);
    if (dirResp != null) list.addAll(dirResp.data);
    return list;
  }

  static Future<String> getDownloadUrl(Authentication auth, File file) async {
    Map resp = await API._rawAPICall(
        auth: auth, path: "/files/file/${file.id}/downloadUrl");
    return (new DownloadResponse.fromJson(resp)).data;
  }
}
