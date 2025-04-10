import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs{
  static void showSneckBar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$msg')));
  }
}