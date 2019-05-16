import 'package:luminus_api/src/announcement.dart';

class AnnouncementResponse {
  String status;
  int code;
  int total;
  int offset;
  List<Announcement> data;

  AnnouncementResponse(
      {this.status, this.code, this.total, this.offset, this.data});

  AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<Announcement>();
      json['data'].forEach((v) {
        data.add(new Announcement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['total'] = this.total;
    data['offset'] = this.offset;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
