import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Console
{

static void WriteToObject(Object message)
{
  print("[DEBUG]: ${message}.");
}

static void Write(String message)
{
  print("[DEBUG]: ${message}.");
}


void messageBox(BuildContext context ,String title, String content)
{
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(title),

         ); });
}

}