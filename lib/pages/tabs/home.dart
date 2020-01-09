import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Go.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("Go"),
        onPressed: () {
          Navigator.pushNamed(context, '/Go');
        },
      ),
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
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            child: Column(
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {},
                                  color: Colors.white,
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "+",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {},
                                  color: Colors.white,
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "-",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Container(
                              width: 40,
                              height: 40,
                              child: RaisedButton(
                                color: Colors.white,
                                onPressed: () {},
                                padding: EdgeInsets.all(5.0),
                                shape: CircleBorder(
                                    side: BorderSide(color: Colors.white)),
                                child: Text(
                                  "+",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
