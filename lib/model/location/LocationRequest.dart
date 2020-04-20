class LocationRequest {
  List<int> intensities;

  LocationRequest(
      {this.intensities});

  LocationRequest.fromJson(Map<String, dynamic> json) {
    intensities = json['intensities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intensities'] = this.intensities;
    return data;
  }
}
