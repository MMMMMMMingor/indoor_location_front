import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}
class RegisterState extends State<RegisterPage>{
  GlobalKey<FormState> loginKey=new GlobalKey<FormState>();
  String userName;
  String password;

  void login(){
      var loginForm=loginKey.currentState;
      if(loginForm.validate()){
        loginForm.save();
        print('userName: '+userName+" password: "+password);
        //由于没有和后端对接，点击之后直接返回
        Navigator.pop(context);
      }
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('登录'),
        ),
        body:new Column(
          children: <Widget>[
            new Container(
                padding:const EdgeInsets.all(16.0),
                child:new Form(
                  key: loginKey,
                  child: new Column(
                    children: <Widget>[
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: '请输入用户名',
                        ),
                        onSaved:(value){
                          userName=value;
                        },
                        onFieldSubmitted: (value){},
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: '请输入密码',
                        ),
                        obscureText: true,
                        validator: (value){
                          return value.length<6?"密码长度不够6位":null;
                        },
                        onSaved:(value){
                          password=value;
                        },
                      )
                    ],
                  ),
                )
            ),
            new SizedBox(
              width: 340.0,
              height: 50.0 ,
              child: new CupertinoButton(
                onPressed: login,
                color: Colors.blue,
                disabledColor: Colors.blue,
                child: new Text(
                  '登录',
                  style: TextStyle(
                      fontSize: 18.0),
                ),
              ),
            )
          ],
        )
    );
  }
}

