import 'package:luminus_api/access.dart';

class BasicFile {
  String id;
  String createdDate;
  String creatorID;
  String lastUpdatedDate;
  String lastUpdatedBy;
  String name;
  bool publish;
  String parentID;
}

class Directory extends BasicFile {
  Access access;
  String id;
  String createdDate;
  String creatorID;
  String lastUpdatedDate;
  String lastUpdatedBy;
  String name;
  String startDate;
  String endDate;
  bool publish;
  String parentID;
  String rootID;
  String sortFilesBy;
  bool allowUpload;
  String uploadDisplayOption;
  bool viewAll;
  double folderScore;
  bool allowComments;
  bool isTurnitinFolder;

  Directory(
      {this.access,
      this.id,
      this.createdDate,
      this.creatorID,
      this.lastUpdatedDate,
      this.lastUpdatedBy,
      this.name,
      this.startDate,
      this.endDate,
      this.publish,
      this.parentID,
      this.rootID,
      this.sortFilesBy,
      this.allowUpload,
      this.uploadDisplayOption,
      this.viewAll,
      this.folderScore,
      this.allowComments,
      this.isTurnitinFolder});

  Directory.fromJson(Map<String, dynamic> json) {
    access =
        json['access'] != null ? new Access.fromJson(json['access']) : null;
    id = json['id'];
    createdDate = json['createdDate'];
    creatorID = json['creatorID'];
    lastUpdatedDate = json['lastUpdatedDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    publish = json['publish'];
    parentID = json['parentID'];
    rootID = json['rootID'];
    sortFilesBy = json['sortFilesBy'];
    allowUpload = json['allowUpload'];
    uploadDisplayOption = json['uploadDisplayOption'];
    viewAll = json['viewAll'];
    folderScore = json['folderScore'];
    allowComments = json['allowComments'];
    isTurnitinFolder = json['isTurnitinFolder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    data['id'] = this.id;
    data['createdDate'] = this.createdDate;
    data['creatorID'] = this.creatorID;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['publish'] = this.publish;
    data['parentID'] = this.parentID;
    data['rootID'] = this.rootID;
    data['sortFilesBy'] = this.sortFilesBy;
    data['allowUpload'] = this.allowUpload;
    data['uploadDisplayOption'] = this.uploadDisplayOption;
    data['viewAll'] = this.viewAll;
    data['folderScore'] = this.folderScore;
    data['allowComments'] = this.allowComments;
    data['isTurnitinFolder'] = this.isTurnitinFolder;
    return data;
  }
}

class File extends BasicFile {
  String id;
  String parentID;
  String resourceID;
  bool publish;
  String name;
  bool allowDownload;
  double fileSize;
  String fileFormat;
  String fileName;
  String creatorID;
  String createdDate;
  String lastUpdatedDate;
  String lastUpdatedBy;

  File(
      {this.id,
      this.parentID,
      this.resourceID,
      this.publish,
      this.name,
      this.allowDownload,
      this.fileSize,
      this.fileFormat,
      this.fileName,
      this.creatorID,
      this.createdDate,
      this.lastUpdatedDate,
      this.lastUpdatedBy});

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentID = json['parentID'];
    resourceID = json['resourceID'];
    publish = json['publish'];
    name = json['name'];
    allowDownload = json['allowDownload'];
    fileSize = json['fileSize'];
    fileFormat = json['fileFormat'];
    fileName = json['fileName'];
    creatorID = json['creatorID'];
    createdDate = json['createdDate'];
    lastUpdatedDate = json['lastUpdatedDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentID'] = this.parentID;
    data['resourceID'] = this.resourceID;
    data['publish'] = this.publish;
    data['name'] = this.name;
    data['allowDownload'] = this.allowDownload;
    data['fileSize'] = this.fileSize;
    data['fileFormat'] = this.fileFormat;
    data['fileName'] = this.fileName;
    data['creatorID'] = this.creatorID;
    data['createdDate'] = this.createdDate;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    return data;
  }
}