import 'package:my_flutter_app1/model/location/AP.dart';

class FingerPrintMetadataRequest {
  List<AP> accessPoints;
  String remark;

  FingerPrintMetadataRequest({this.accessPoints, this.remark});

  FingerPrintMetadataRequest.fromJson(Map<String, dynamic> json) {
    if (json['accessPoints'] != null) {
      accessPoints = new List<AP>();
      json['accessPoints'].forEach((v) {
        accessPoints.add(new AP.fromJson(v));
      });
    }
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessPoints != null) {
      data['accessPoints'] = this.accessPoints.map((v) => v.toJson()).toList();
    }
    data['remark'] = this.remark;
    return data;
  }
}