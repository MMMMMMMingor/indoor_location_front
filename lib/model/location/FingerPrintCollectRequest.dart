class FingerPrintCollectRequest {
  int x;
  int y;
  List<int> intensities;
  bool finish;

  FingerPrintCollectRequest({this.x, this.y, this.intensities, this.finish});

  FingerPrintCollectRequest.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    intensities = json['intensities'].cast<int>();
    finish = json['finish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['intensities'] = this.intensities;
    data['finish'] = this.finish;
    return data;
  }
}
