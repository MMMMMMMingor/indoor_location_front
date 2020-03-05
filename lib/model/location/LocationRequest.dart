class LocationRequest {
  List<int> intensities;
  bool finish;

  LocationRequest(
      {this.intensities, this.finish});

  LocationRequest.fromJson(Map<String, dynamic> json) {
    intensities = json['intensities'];
    finish = json['finish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intensities'] = this.intensities;
    data['finish'] = this.finish;
    return data;
  }
}
