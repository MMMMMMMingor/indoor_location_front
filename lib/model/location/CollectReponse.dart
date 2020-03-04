class CollectReponse {
  String describe;
  bool success;
  String topic;

  CollectReponse({this.describe, this.success, this.topic});

  CollectReponse.fromJson(Map<String, dynamic> json) {
    describe = json['describe'];
    success = json['success'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['describe'] = this.describe;
    data['success'] = this.success;
    data['topic'] = this.topic;
    return data;
  }
}
