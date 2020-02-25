import 'package:my_flutter_app1/model/AP.dart';

class ThreeAPs {
  AP ap1;
  AP ap2;
  AP ap3;

  ThreeAPs({this.ap1, this.ap2, this.ap3});

  ThreeAPs.fromJson(Map<String, dynamic> json) {
    ap1 = json['ap1'] != null ? new AP.fromJson(json['ap1']) : null;
    ap2 = json['ap2'] != null ? new AP.fromJson(json['ap2']) : null;
    ap3 = json['ap3'] != null ? new AP.fromJson(json['ap3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ap1 != null) {
      data['ap1'] = this.ap1.toJson();
    }
    if (this.ap2 != null) {
      data['ap2'] = this.ap2.toJson();
    }
    if (this.ap3 != null) {
      data['ap3'] = this.ap3.toJson();
    }
    return data;
  }
}
