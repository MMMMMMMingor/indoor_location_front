//单例模式
class User{

  static User _instance;
  String url;
  String name;
  String password;
  String sex;
  int age;
  String job;
  String notation;

  User._internal() {
    // 初始化
    url="images/head_portraits.jpg";
    name='小明';
    password='123456';
    sex='男';
    age=20;
    job='学生';
    notation='吃货';
  }
  static User _getInstance() {
    if (_instance == null) {
      _instance = new User._internal();
    }
    return _instance;
  }
  factory User() =>_getInstance();
  static User get instance => _getInstance();

  void myprint(){
    print("url= "+this.url+'\n'
        +'name= '+name+'\n'
        +'password= '+password+'\n'
        +'sex= '+sex+'\n'
        +'age= '+age.toString()+'\n'
        +'job= '+job+'\n'
        +'notation= '+notation+'\n'
    );
  }
}

