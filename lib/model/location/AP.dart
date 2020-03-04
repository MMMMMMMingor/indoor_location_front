class AP {
  String bssid;
  String ssid;
  double x;
  double y;

  AP({this.bssid, this.ssid, this.x, this.y});

  AP.fromJson(Map<String, dynamic> json) {
    bssid = json['bssid'];
    ssid = json['ssid'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bssid'] = this.bssid;
    data['ssid'] = this.ssid;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}