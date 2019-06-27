import 'notification.dart';

class NotificationResponse {
  String status;
  int code;
  int total;
  int offset;
  int limit;
  List<Notification> data;

  NotificationResponse(
      {this.status, this.code, this.total, this.offset, this.limit, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    limit = json['limit'];
    if (json['data'] != null) {
      data = new List<Notification>();
      json['data'].forEach((v) {
        data.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['total'] = this.total;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
