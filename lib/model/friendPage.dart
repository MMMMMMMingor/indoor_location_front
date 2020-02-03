class FriendPage {
  List<Friend> _records;
  int _total;
  int _size;
  int _current;
  bool _searchCount;
  int _pages;

  FriendPage(
      {List<Friend> records,
      int total,
      int size,
      int current,
      bool searchCount,
      int pages}) {
    this._records = records;
    this._total = total;
    this._size = size;
    this._current = current;
    this._searchCount = searchCount;
    this._pages = pages;
  }

  List<Friend> get records => _records;
  set records(List<Friend> records) => _records = records;
  int get total => _total;
  set total(int total) => _total = total;
  int get size => _size;
  set size(int size) => _size = size;
  int get current => _current;
  set current(int current) => _current = current;
  bool get searchCount => _searchCount;
  set searchCount(bool searchCount) => _searchCount = searchCount;
  int get pages => _pages;
  set pages(int pages) => _pages = pages;

  FriendPage.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      _records = new List<Friend>();
      json['records'].forEach((v) {
        _records.add(new Friend.fromJson(v));
      });
    }
    _total = json['total'];
    _size = json['size'];
    _current = json['current'];
    _searchCount = json['searchCount'];
    _pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._records != null) {
      data['records'] = this._records.map((v) => v.toJson()).toList();
    }
    data['total'] = this._total;
    data['size'] = this._size;
    data['current'] = this._current;
    data['searchCount'] = this._searchCount;
    data['pages'] = this._pages;
    return data;
  }
}

class Friend {
  String _id;
  String _userId;
  String _friendId;
  String _createTime;

  Friend({String id, String userId, String friendId, String createTime}) {
    this._id = id;
    this._userId = userId;
    this._friendId = friendId;
    this._createTime = createTime;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get friendId => _friendId;
  set friendId(String friendId) => _friendId = friendId;
  String get createTime => _createTime;
  set createTime(String createTime) => _createTime = createTime;

  Friend.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['userId'];
    _friendId = json['friendId'];
    _createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['userId'] = this._userId;
    data['friendId'] = this._friendId;
    data['createTime'] = this._createTime;
    return data;
  }
}
