import 'package:flutter/material.dart';

class Go extends StatefulWidget {
  const Go({Key key}) : super(key: key);

  GoState createState() => GoState();
}

class GoState extends State<Go> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          child:
              Padding(padding: EdgeInsets.all(20.0), child: First()),
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}

class First extends StatelessWidget {
  List<Widget> _getdata() {
    List<Widget> listView = new List();
    for (var i = 0; i < 5; i++) {
      listView.add(
        ListTile(
          title: Text("我的位置——xxxxxx"),
        ),
      );
    }
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    border: Border.all(
                                                        color: Colors.white70,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                150.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Center(
                                                child: Container(
                                                  child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                      decoration: InputDecoration
                                                          .collapsed(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText: "输入起点",
                                                              hintStyle:
                                                                  TextStyle())),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                    Divider(
                                      height: 1.0,
                                      indent: 30.0,
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    border: Border.all(
                                                        color: Colors.white70,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                150.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Center(
                                                child: Container(
                                                  child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                      decoration: InputDecoration
                                                          .collapsed(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText: "输入终点",
                                                              hintStyle:
                                                                  TextStyle())),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white70, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(150.0))),
                        child: Center(
                          child: IconButton(
                              icon: Icon(Icons.add),
                              padding: EdgeInsets.all(4.0),
                              iconSize: 30,
                              onPressed: () {
                                     Navigator.pushNamed(context, '/GoExpand');

                              },
                              color: Colors.blueAccent,
                              highlightColor: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      key: ValueKey("text"),
                      child: Text("历史记录"),
                      onPressed: () {},
                      textTheme: ButtonTextTheme.normal,
                      textColor: Colors.blue,
                      disabledTextColor: Colors.red,
                      color: Colors.white,
                      disabledColor: Colors.grey,
                      highlightColor: Colors.grey,
                      // 按下的背景色
                      splashColor: Colors.green,
                      // 水波纹颜色
                      colorBrightness: Brightness.light,
                      // 主题
                      elevation: 10,
                      highlightElevation: 10,
                      disabledElevation: 10,
                      padding: EdgeInsets.all(10),
//       MaterialButton shape 子类才起效
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                              color: Color(0xFFFFFFFF),
                              style: BorderStyle.solid,
                              width: 1)),
                      clipBehavior: Clip.antiAlias,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      animationDuration: Duration(seconds: 1),
                      minWidth: 200,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      key: ValueKey("text"),
                      child: Text("我的收藏"),
                      onPressed: () {},
                      textTheme: ButtonTextTheme.normal,
                      textColor: Colors.blue,
                      disabledTextColor: Colors.red,
                      color: Colors.white,
                      disabledColor: Colors.grey,
                      highlightColor: Colors.grey,
                      // 按下的背景色
                      splashColor: Colors.green,
                      // 水波纹颜色
                      colorBrightness: Brightness.light,
                      // 主题
                      elevation: 10,
                      highlightElevation: 10,
                      disabledElevation: 10,
                      padding: EdgeInsets.all(10),
//       MaterialButton shape 子类才起效
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                              color: Color(0xFFFFFFFF),
                              style: BorderStyle.solid,
                              width: 1)),
                      clipBehavior: Clip.antiAlias,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      animationDuration: Duration(seconds: 1),
                      minWidth: 200,
                      height: 50,
                    ),
                  )
                ],
              ),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: ListView(children: this._getdata()),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration());
  }
}


