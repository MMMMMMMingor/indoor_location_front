

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
        child:Center(
            child:Text('首页',
              style: Theme.of(context).textTheme.button,)
        )
    );

  }
}