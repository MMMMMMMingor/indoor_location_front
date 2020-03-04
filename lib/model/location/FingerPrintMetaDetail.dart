
import 'package:my_flutter_app1/model/location/AP.dart';

class FingerPrintMetaDetail {
  String metadataId;
  List<AP> accessPoints;
  int count;

  FingerPrintMetaDetail({this.metadataId, this.accessPoints, this.count});

  FingerPrintMetaDetail.fromJson(Map<String, dynamic> json) {
    metadataId = json['metadataId'];
    if (json['accessPoints'] != null) {
      accessPoints = new List<AP>();
      json['accessPoints'].forEach((v) {
        accessPoints.add(new AP.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['metadataId'] = this.metadataId;
    if (this.accessPoints != null) {
      data['accessPoints'] = this.accessPoints.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}
