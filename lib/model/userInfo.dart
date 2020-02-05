class UserInfo {
  int age;
  String avatarUrl;
  String gender;
  String nickname;
  String personLabel;
  String userId;
  String vocation;

  UserInfo(
      {this.age,
        this.avatarUrl,
        this.gender,
        this.nickname,
        this.personLabel,
        this.userId,
        this.vocation});

  UserInfo.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    avatarUrl = json['avatarUrl'];
    gender = json['gender'];
    nickname = json['nickname'];
    personLabel = json['personLabel'];
    userId = json['userId'];
    vocation = json['vocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['avatarUrl'] = this.avatarUrl;
    data['gender'] = this.gender;
    data['nickname'] = this.nickname;
    data['personLabel'] = this.personLabel;
    data['userId'] = this.userId;
    data['vocation'] = this.vocation;
    return data;
  }
}
