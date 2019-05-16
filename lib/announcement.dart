import 'package:luminus_api/access.dart';

class Announcement {
  String id;
  String parentID;
  String title;
  String description;
  String displayFrom;
  String expireAfter;
  String archiveAfter;
  bool publish;
  bool sms;
  bool email;
  Access access;
  String createdDate;
  String creatorID;
  String lastUpdatedDate;
  String lastUpdatedBy;

  Announcement(
      {this.id,
      this.parentID,
      this.title,
      this.description,
      this.displayFrom,
      this.expireAfter,
      this.archiveAfter,
      this.publish,
      this.sms,
      this.email,
      this.access,
      this.createdDate,
      this.creatorID,
      this.lastUpdatedDate,
      this.lastUpdatedBy});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentID = json['parentID'];
    title = json['title'];
    description = json['description'];
    displayFrom = json['displayFrom'];
    expireAfter = json['expireAfter'];
    archiveAfter = json['archiveAfter'];
    publish = json['publish'];
    sms = json['sms'];
    email = json['email'];
    access =
        json['access'] != null ? new Access.fromJson(json['access']) : null;
    createdDate = json['createdDate'];
    creatorID = json['creatorID'];
    lastUpdatedDate = json['lastUpdatedDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentID'] = this.parentID;
    data['title'] = this.title;
    data['description'] = this.description;
    data['displayFrom'] = this.displayFrom;
    data['expireAfter'] = this.expireAfter;
    data['archiveAfter'] = this.archiveAfter;
    data['publish'] = this.publish;
    data['sms'] = this.sms;
    data['email'] = this.email;
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    data['createdDate'] = this.createdDate;
    data['creatorID'] = this.creatorID;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    return data;
  }
}