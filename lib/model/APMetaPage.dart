import 'package:my_flutter_app1/model/APMeta.dart';

class APMetaPage {
  int current;
  int pages;
  List<APMeta> records;
  bool searchCount;
  int size;
  int total;

  APMetaPage(
      {this.current,
      this.pages,
      this.records,
      this.searchCount,
      this.size,
      this.total});

  APMetaPage.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    pages = json['pages'];
    if (json['records'] != null) {
      records = new List<APMeta>();
      json['records'].forEach((v) {
        records.add(new APMeta.fromJson(v));
      });
    }
    searchCount = json['searchCount'];
    size = json['size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;
    data['pages'] = this.pages;
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    data['searchCount'] = this.searchCount;
    data['size'] = this.size;
    data['total'] = this.total;
    return data;
  }
}
