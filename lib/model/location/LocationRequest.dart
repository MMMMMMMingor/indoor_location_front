class LocationRequest {
  int intensity1;
  int intensity2;
  int intensity3;
  bool finish;

  LocationRequest(
      {this.intensity1, this.intensity2, this.intensity3, this.finish});

  LocationRequest.fromJson(Map<String, dynamic> json) {
    intensity1 = json['intensity1'];
    intensity2 = json['intensity2'];
    intensity3 = json['intensity3'];
    finish = json['finish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intensity1'] = this.intensity1;
    data['intensity2'] = this.intensity2;
    data['intensity3'] = this.intensity3;
    data['finish'] = this.finish;
    return data;
  }
}
