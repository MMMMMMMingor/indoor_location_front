class ImageUrl {
  bool success;
  String imageUrl;
  String describe;

  ImageUrl({this.success, this.imageUrl, this.describe});

  ImageUrl.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    imageUrl = json['imageUrl'];
    describe = json['describe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['imageUrl'] = this.imageUrl;
    data['describe'] = this.describe;
    return data;
  }
}
