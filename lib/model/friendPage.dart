class FriendPage {
  int current;
  int pages;
  List<Friend> records;
  bool searchCount;
  int size;
  int total;

  FriendPage(
      {this.current,
        this.pages,
        this.records,
        this.searchCount,
        this.size,
        this.total});

  FriendPage.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    pages = json['pages'];
    if (json['records'] != null) {
      records = new List<Friend>();
      json['records'].forEach((v) {
        records.add(new Friend.fromJson(v));
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

class Friend {
  String createTime;
  String friendId;
  String id;
  String userId;

  Friend({this.createTime, this.friendId, this.id, this.userId});

  Friend.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    friendId = json['friendId'];
    id = json['id'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['friendId'] = this.friendId;
    data['id'] = this.id;
    data['userId'] = this.userId;
    return data;
  }
}
