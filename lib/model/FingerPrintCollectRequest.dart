class FingerPrintCollectRequest {
  int x;
  int y;
  int ap1;
  int ap2;
  int ap3;
  bool finish;

  FingerPrintCollectRequest(
      {this.x, this.y, this.ap1, this.ap2, this.ap3, this.finish});

  FingerPrintCollectRequest.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    ap1 = json['ap1'];
    ap2 = json['ap2'];
    ap3 = json['ap3'];
    finish = json['finish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['ap1'] = this.ap1;
    data['ap2'] = this.ap2;
    data['ap3'] = this.ap3;
    data['finish'] = this.finish;
    return data;
  }
}
