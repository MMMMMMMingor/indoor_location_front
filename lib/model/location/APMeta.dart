import 'package:my_flutter_app1/model/location/AP.dart';

class APMeta {
  List<AP> accessPoints;
  String createTime;
  String metaId;
  int count;
  String remark;
  String userId;

  APMeta(
      {this.accessPoints,
      this.createTime,
      this.metaId,
      this.count,
      this.remark,
      this.userId});

  APMeta.fromJson(Map<String, dynamic> json) {
    if (json['accessPoints'] != null) {
      accessPoints = new List<AP>();
      json['accessPoints'].forEach((v) {
        accessPoints.add(new AP.fromJson(v));
      });
    }
    createTime = json['createTime'];
    metaId = json['metaId'];
    count = json['count'];
    remark = json['remark'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessPoints != null) {
      data['accessPoints'] = this.accessPoints.map((v) => v.toJson()).toList();
    }
    data['createTime'] = this.createTime;
    data['metaId'] = this.metaId;
    data['count'] = this.count;
    data['remark'] = this.remark;
    data['userId'] = this.userId;
    return data;
  }
}
