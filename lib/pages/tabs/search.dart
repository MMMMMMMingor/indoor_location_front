

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SearchPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        // child:Center(
        //     child:Text('发现',
        //       style: Theme.of(context).textTheme.button,)
        // )
    resizeToAvoidBottomPadding: false,
    body: Container(
      height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/searchBack.jpg"),
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
                                style: TextStyle(fontSize: 30),
                                decoration: InputDecoration.collapsed(
                                    border: InputBorder.none,
                                    hintText: "搜索地址",
                                    hintStyle: TextStyle())),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.search),
                                padding:EdgeInsets.all(10.0),
                              iconSize: 30,
                              
                              onPressed: (){

                                print("aa");
                              },
                                color: Colors.blueAccent,
                                highlightColor: Colors.black
                            ),
                          )
              ],),
              )
          ],
        ),
      ),
    ),
     )
    )
    );
  }
}
