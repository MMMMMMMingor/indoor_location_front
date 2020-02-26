class APMeta {
  String bssid1;
  String bssid2;
  String bssid3;
  String createTime;
  String metaId;
  String userId;

  APMeta(
      {this.bssid1,
      this.bssid2,
      this.bssid3,
      this.createTime,
      this.metaId,
      this.userId});

  APMeta.fromJson(Map<String, dynamic> json) {
    bssid1 = json['bssid1'];
    bssid2 = json['bssid2'];
    bssid3 = json['bssid3'];
    createTime = json['createTime'];
    metaId = json['metaId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bssid1'] = this.bssid1;
    data['bssid2'] = this.bssid2;
    data['bssid3'] = this.bssid3;
    data['createTime'] = this.createTime;
    data['metaId'] = this.metaId;
    data['userId'] = this.userId;
    return data;
  }
}