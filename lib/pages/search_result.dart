import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SearchResult extends StatefulWidget {
  SearchResult({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/head_portraits.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: TextField(
                                style: TextStyle(fontSize: 25),
                                decoration: InputDecoration.collapsed(
                                    border: InputBorder.none,
                                    hintText: "搜索地址",
                                    hintStyle: TextStyle())),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                icon: Icon(Icons.search),
                                padding: EdgeInsets.all(10.0),
                                iconSize: 30,
                                onPressed: () {
                                },
                                color: Colors.blueAccent,
                                highlightColor: Colors.black),
                          )
                        ],
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.white70, width: 2),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                    ),
                    Expanded(flex: 2, child: Container()),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text("华南理工大学",
                                textAlign:TextAlign.left,
                            style: TextStyle(

                            ),),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("5.0km",
                              textAlign:TextAlign.left,
                              style: TextStyle(

                              ),),
                          ),
                          Expanded(
                            flex:1,
                            child: Text("约5分钟",
                              textAlign:TextAlign.left,
                              style: TextStyle(

                              ),),
                          ),
                          Divider(height: 1.0,indent: 0.0,color: Colors.black,),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: MaterialButton(
                            child: Text("导航"),
                            onPressed:(){},
                            textTheme: ButtonTextTheme.normal,
                            textColor: Colors.black,
                            disabledTextColor: Colors.red,
                            color:Colors.blue,
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
                                    color: Color(0xFFFFFFFF), style: BorderStyle.solid, width: 1)),
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
                                    child: Text("路线"),
                                    onPressed:(){},
                                    textTheme: ButtonTextTheme.normal,
                                    textColor: Colors.white,
                                    disabledTextColor: Colors.red,
                                    color:Colors.blue,
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
                                            color: Color(0xFFFFFFFF), style: BorderStyle.solid, width: 1)),
                                    clipBehavior: Clip.antiAlias,
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    animationDuration: Duration(seconds: 1),
                                    minWidth: 200,
                                    height: 50,
                                  ),
                                )
                              ],
                            ),
                          )

                        ],
                      ),
                       decoration: BoxDecoration(
                           color: Colors.white,
                           border: Border.all(color: Colors.white70, width: 0),
                           borderRadius:
                           BorderRadius.all(Radius.circular(10.0))),
                      height: 150,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
