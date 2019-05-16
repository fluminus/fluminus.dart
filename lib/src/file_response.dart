import 'package:luminus_api/src/file.dart';

class FileResponse {
  String status;
  int code;
  int total;
  int offset;
  List<File> data;

  FileResponse({this.status, this.code, this.total, this.offset, this.data});

  FileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<File>();
      json['data'].forEach((v) {
        data.add(new File.fromJson(v));
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

class SubdirectoryResponse {
  String status;
  int code;
  int total;
  int offset;
  List<Directory> data;

  SubdirectoryResponse(
      {this.status, this.code, this.total, this.offset, this.data});

  SubdirectoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = new List<Directory>();
      json['data'].forEach((v) {
        data.add(new Directory.fromJson(v));
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
