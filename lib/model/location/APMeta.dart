import 'package:my_flutter_app1/model/location/AP.dart';

class APMeta {
  List<AP> accessPoints;
  String createTime;
  String metaId;
  String remark;
  String userId;

  APMeta(
      {this.accessPoints,
      this.createTime,
      this.metaId,
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
    data['remark'] = this.remark;
    data['userId'] = this.userId;
    return data;
  }
}
