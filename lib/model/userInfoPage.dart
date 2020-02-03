import './userInfo.dart';

class UserInfoPage {
  List<UserInfo> _records;
  int _total;
  int _size;
  int _current;
  bool _searchCount;
  int _pages;

  UserInfoPage(
      {List<UserInfo> records,
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

  List<UserInfo> get records => _records;
  set records(List<UserInfo> records) => _records = records;
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

  UserInfoPage.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      _records = new List<UserInfo>();
      json['records'].forEach((v) {
        _records.add(new UserInfo.fromJson(v));
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
