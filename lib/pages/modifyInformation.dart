import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class ModifyInformation extends StatefulWidget {
  @override
  ModifyInforState createState() => ModifyInforState();
}
class ModifyInforState extends State<ModifyInformation> {
  GlobalKey<FormState> saveKey=new GlobalKey<FormState>();

  //_imagePath存储用户临时选择尚未确认的头像图片路径
  var _imagePath=User.instance.url;
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image.path;
      print(_imagePath);
    });
  }

  void save(){
    var saveForm=saveKey.currentState;

    if(saveForm.validate()){
      saveForm.save();
      User.instance.url=_imagePath;
      User.instance.myprint();
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar:new AppBar(
          title:new Text('修改个人信息'),
        ),
        body: new SingleChildScrollView(
          child:new Form(
            key: saveKey,
            child: new Column(
                children:<Widget>[
                  new Container(
                      width: 150.0,
                      height: 150.0,
                      child:Center(
                        child:new GestureDetector(
                          child: new ClipOval(
                            child: new SizedBox(
                              width: 120,
                              height: 120,
                              child: _imagePath=='images/head_portraits.jpg'?
                              Image.asset(_imagePath,fit: BoxFit.fill,):Image.file(File(_imagePath),fit: BoxFit.fill),
                            ),
                          ),
                          onTap: _openGallery,
                        )
                      )

                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '昵称  ',
                        style: new TextStyle(
                            fontSize:20,
                            color: Colors.grey
                        ),),
                      new SizedBox(
                        width: 245,
                        child: new TextFormField(
                          onSaved: (value){
                            if(value!=""){
                              User.instance.name=value;
                            }
                          },
                          style: new TextStyle(
                              fontSize:20
                          ),
                          decoration: new InputDecoration(
                              hintText: User.instance.name
                          ),
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '性别  ',
                        style: new TextStyle(
                            fontSize:20,
                            color: Colors.grey
                        ),),
                      new SizedBox(
                        width: 245,
                        child: new TextFormField(
                          onSaved: (value){
                            if(value!="") {
                              User.instance.sex = value;
                            }
                          },
                          style: new TextStyle(
                              fontSize:20
                          ),
                          decoration: new InputDecoration(
                              hintText: User.instance.sex
                          ),
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '年龄  ',
                        style: new TextStyle(
                            fontSize:20,
                            color: Colors.grey
                        ),),
                      new SizedBox(
                        width: 245,
                        child: new TextFormField(
                          onSaved: (value){
                            if(value!="") {
                              User.instance.age = int.parse(value);
                            }
                          },
                          style: new TextStyle(
                              fontSize:20
                          ),
                          decoration: new InputDecoration(
                              hintText: User.instance.age.toString()
                          ),
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '职业  ',
                        style: new TextStyle(
                            fontSize:20,
                            color: Colors.grey
                        ),),
                      new SizedBox(
                        width: 245,
                        child: new TextFormField(
                          onSaved: (value){
                            if(value!=""){
                             User.instance.job=value;
                            }
                          },
                          style: new TextStyle(
                              fontSize:20
                          ),
                          decoration: new InputDecoration(
                              hintText: User.instance.job
                          ),
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '个人标签  ',
                        style: new TextStyle(
                            fontSize:20,
                            color: Colors.grey
                        ),),
                      new SizedBox(
                        width: 205,
                        child: new TextFormField(
                          onSaved: (value){
                            if(value!="") {
                              User.instance.notation = value;
                            }
                          },
                          style: new TextStyle(
                              fontSize:20
                          ),
                          decoration: new InputDecoration(
                              hintText: User.instance.notation
                          ),
                        ),
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 10,
                  ),
                  new Container(
                    width: 260,
                    height: 50,
                    child:  new CupertinoButton(
                      child: Text('保存修改'),
                      color: Colors.blue,
                      disabledColor: Colors.blue,
                      onPressed: (){
                        save();
                        Navigator.pop(context);
                      },
                    ),
                  )
                ]
            ),
          )

        )
    );
  }
}