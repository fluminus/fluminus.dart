library luminus_api;

export 'src/luminus_api_base.dart';
export 'package:luminus_api/src/module.dart';
export 'package:luminus_api/src/announcement.dart';
export 'package:luminus_api/src/profile.dart';
export 'package:luminus_api/src/file.dart';
export 'package:luminus_api/src/authorization.dart';
export 'package:luminus_api/src/exception.dart';
export 'package:luminus_api/src/notification.dart';

import 'dart:async';

import 'package:dio/dio.dart';
// import 'package:dotenv/dotenv.dart';
import 'package:luminus_api/src/notification.dart';
import 'package:luminus_api/src/notification_response.dart';

import 'src/announcement_response.dart';
import 'src/download_response.dart';
import 'src/file_response.dart';
import 'src/module_response.dart';

import 'package:luminus_api/src/module.dart';
import 'package:luminus_api/src/announcement.dart';
import 'package:luminus_api/src/profile.dart';
import 'package:luminus_api/src/file.dart';
import 'package:luminus_api/src/authorization.dart';

/// Wrapper class of [luminus_api] package, including the automated authentication flow, data retrieval methods and corresponding data abstraction classes.
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
    var resp = await dio.get(uri, options: Options(headers: headers));
    return resp.data;
  }

  static Future<Map> rawAPICall(
      {Authentication auth, String path, bool isTest = false}) async {
    Map parsed = await _apiGet(await auth.getAuth(), path);
    return parsed;
  }

  // Module related APIs

  /// Returns a list of [Module] taken by user specified by [auth].
  static Future<List<Module>> getModules(FutureOr<Authentication> auth) async {
    Map resp = await rawAPICall(auth: await auth, path: '/module');
    var modules = new ModuleResponse.fromJson(resp);
    return modules.data;
  }

  // Announcement related APIs

  /// Returns a list of [Announcement] from [module] taken by user specified by [auth].
  /// [archived] is default as `false`, which limits the returned result to the latest semester.
  static Future<List<Announcement>> getAnnouncements(
      FutureOr<Authentication> auth, Module module,
      {bool archived = false}) async {
    Map resp = await API.rawAPICall(
        auth: await auth,
        path:
            "/announcement/${archived ? 'Archived' : 'NonArchived'}/${module.id}?=displayFrom%20ASC");
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  /// Get active announcements
  /// Populate additional information. Accepted entities: creator, lastUpdatedUser, parent
  static Future<List<Announcement>> ActiveAnnouncements(
      FutureOr<Authentication> auth,
      {String sortby,
      int offset,
      int limit,
      String where,
      String populate,
      bool titleOnly = true}) async {
    String query = _formatQueryArgument({
      'sortby': sortby,
      'offset': offset,
      'limit': limit,
      'where': where,
      'populate': populate,
      'titleOnly': titleOnly
    });
    String path = '/announcement/Active' + query;
    Map resp = await API.rawAPICall(auth: await auth, path: path);
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  /// Get unread announcements
  static Future<List<Announcement>> getUnreadAnnouncements(Authentication auth,
      {String sortby,
      int offset,
      int limit,
      String where,
      String populate,
      bool titleOnly = true}) async {
    String query = _formatQueryArgument({
      'sortby': sortby,
      'offset': offset,
      'limit': limit,
      'where': where,
      'populate': populate,
      'titleOnly': titleOnly
    });
    String path = '/announcement/Unread?titleOnly=${titleOnly}' + query;
    Map resp = await API.rawAPICall(auth: auth, path: path);
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  /// Get active announcements by Module
  static Future<List<Announcement>> getActiveAnnouncementsByModule(
      Authentication auth, String parentID,
      {String sortby,
      int offset,
      int limit,
      String where,
      String populate,
      bool titleOnly = true}) async {
    String query = _formatQueryArgument({
      'sortby': sortby,
      'offset': offset,
      'limit': limit,
      'where': where,
      'populate': populate,
      'titleOnly': titleOnly
    });
    String path =
        '/announcement/Active/${parentID}?titleOnly=${titleOnly}' + query;
    Map resp = await API.rawAPICall(auth: auth, path: path);
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  /// Get archived announcements by Module
  static Future<List<Announcement>> getArchivedAnnouncementsByModule(
      Authentication auth, String parentID,
      {String sortby,
      int offset,
      int limit,
      String where,
      String populate,
      bool titleOnly = true}) async {
    String query = _formatQueryArgument({
      'sortby': sortby,
      'offset': offset,
      'limit': limit,
      'where': where,
      'populate': populate,
      'titleOnly': titleOnly
    });
    String path =
        '/announcement/Archived/${parentID}?titleOnly=${titleOnly}' + query;
    Map resp = await API.rawAPICall(auth: auth, path: path);
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  /// Get non-archived announcementd by Module
  static Future<List<Announcement>> getNonArchivedAnnouncementsByModule(
      Authentication auth, String parentID,
      {String sortby,
      int offset,
      int limit,
      String where,
      String populate,
      bool titleOnly = true}) async {
    String query = _formatQueryArgument({
      'sortby': sortby,
      'offset': offset,
      'limit': limit,
      'where': where,
      'populate': populate,
      'titleOnly': titleOnly
    });
    String path =
        '/announcement/NonArchived/${parentID}?titleOnly=${titleOnly}' + query;
    Map resp = await API.rawAPICall(auth: auth, path: path);
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  // static String formatQueryArgument(String name, dynamic value) =>
  //     value == null ? '' : '&${name}=${value}';

  static String _formatQueryArgument(Map<String, dynamic> query) {
    bool hasValue = false;
    String res = '';
    query.forEach((String name, dynamic value) {
      if (value != null) {
        if (!hasValue) {
          hasValue = true;
          res += '?$name=$value';
        } else {
          res += '&$name=$value';
        }
      }
    });
    return res;
  }

  // Personal information related APIs

  /// Returns a [Profile] object
  static Future<Profile> getProfile(FutureOr<Authentication> auth) async {
    Map resp = await API.rawAPICall(auth: await auth, path: "/user/profile");
    var profile = new Profile.fromJson(resp);
    return profile;
  }

  // File related APIs

  /// Returns a list of [Directory] rooted with the given [module].
  /// Normally there shouldn't be [File] under a [Module], if such things do happen,
  /// or LumiNUS does allow module coordinators to do so, please post an issue in GitHub.
  static Future<List<Directory>> getModuleDirectories(
      FutureOr<Authentication> auth, Module module) async {
    Map resp = await API.rawAPICall(
        auth: await auth, path: "/files/?ParentID=${module.id}");
    return (new SubdirectoryResponse.fromJson(resp)).data;
  }

  /// Returns a list of [Directory] rooted with the given [dir].
  static Future<List<Directory>> getSubdirectories(
      FutureOr<Authentication> auth, Directory dir) async {
    Map resp = await API.rawAPICall(
        auth: await auth, path: "/files/?ParentID=${dir.id}");
    return (new SubdirectoryResponse.fromJson(resp)).data;
  }

  /// Returns a list of [BasicFile] rooted with the given [dir].
  /// *items* in the function name refer to both [Directory] and [File], which
  /// are subclasses of [BasicFile], by calling this function we can display
  /// both files and subdirectories under [dir].
  static Future<List<BasicFile>> getItemsFromDirectory(
      FutureOr<Authentication> auth, Directory dir) async {
    // Get the subdirectories
    var fileResp = FileResponse.fromJson(await API.rawAPICall(
        auth: await auth,
        path:
            "/files/${dir.id}/file${dir.allowUpload ? '?populate=Creator' : ''}"));
    var dirResp = SubdirectoryResponse.fromJson(await API.rawAPICall(
        auth: await auth, path: "/files/?ParentID=${dir.id}"));
    List<BasicFile> list = new List();
    if (fileResp != null) list.addAll(fileResp.data);
    if (dirResp != null) list.addAll(dirResp.data);
    return list;
  }

  /// Return the download url of a given [file], note that this url can only be used once.
  static Future<String> getDownloadUrl(
      FutureOr<Authentication> auth, File file) async {
    Map resp = await API.rawAPICall(
        auth: await auth, path: "/files/file/${file.id}/downloadUrl");
    return (new DownloadResponse.fromJson(resp)).data;
  }

  /// Notification API

  static Future<List<Notification>> getNotifications(
      FutureOr<Authentication> auth,
      {String sortby,
      int offset,
      int limit,
      String where,
      String populate}) async {
    String query = _formatQueryArgument({
      'sortby': sortby,
      'offset': offset,
      'limit': limit,
      'where': where,
      'populate': populate,
    });
    String path = '/notification' + query;
    Map resp = await API.rawAPICall(auth: await auth, path: path);
    return NotificationResponse.fromJson(resp).data;
  }
}

// main(List<String> args) async {
//   load();
//   var auth = Authentication(
//           password: env['LUMINUS_PASSWORD'], username: env['LUMINUS_USERNAME']);
// print(await API.getUnreadAnnouncements(auth, limit: 1));
// print(await API.getActiveAnnouncementsByModule(auth, 'e6cc862f-f579-4414-9139-b5a88784c73c'));
// print(await API.getArchivedAnnouncementsByModule(auth, 'e6cc862f-f579-4414-9139-b5a88784c73c'));
// List<Announcement> my = await API.getNonArchivedAnnouncementsByModule(auth, 'e6cc862f-f579-4414-9139-b5a88784c73c');
// print(my[0].id);
// load();
// Future<Authentication> auth = Future.delayed(
//     Duration(seconds: 3),
//     () => Authentication(
//         password: env['LUMINUS_PASSWORD'],
//         username: env['LUMINUS_USERNAME']));

// await Future.delayed(const Duration(seconds: 5));

/*   var wrongAuth = Authentication(username: 'e0261956', password: 'asdasd');
    try {
      print(await wrongAuth.getAuth());
    } catch (e) {
      print(e);
    } */
// }
