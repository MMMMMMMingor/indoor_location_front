class UserInfo {
  String _userId;
  String _nickname;
  String _gender;
  int _age;
  String _vocation;
  String _personLabel;
  String _avatarUrl;

  UserInfo(
      {String userId,
      String nickname,
      String gender,
      int age,
      String vocation,
      String personLabel,
      String avatarUrl}) {
    this._userId = userId;
    this._nickname = nickname;
    this._gender = gender;
    this._age = age;
    this._vocation = vocation;
    this._personLabel = personLabel;
    this._avatarUrl = avatarUrl;
  }

  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;
  String get gender => _gender;
  set gender(String gender) => _gender = gender;
  int get age => _age;
  set age(int age) => _age = age;
  String get vocation => _vocation;
  set vocation(String vocation) => _vocation = vocation;
  String get personLabel => _personLabel;
  set personLabel(String personLabel) => _personLabel = personLabel;
  String get avatarUrl => _avatarUrl;
  set avatarUrl(String avatarUrl) => _avatarUrl = avatarUrl;

  UserInfo.fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _nickname = json['nickname'];
    _gender = json['gender'];
    _age = json['age'];
    _vocation = json['vocation'];
    _personLabel = json['personLabel'];
    _avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['nickname'] = this._nickname;
    data['gender'] = this._gender;
    data['age'] = this._age;
    data['vocation'] = this._vocation;
    data['personLabel'] = this._personLabel;
    data['avatarUrl'] = this._avatarUrl;
    return data;
  }
}