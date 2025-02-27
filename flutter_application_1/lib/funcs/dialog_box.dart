// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/funcs/button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  final ammontController;
  VoidCallback onSave;
  VoidCallback onCancel; 
    DialogBox({
      super.key, 
      required this.ammontController,
      required this.controller,
      required this.onSave,
      required this.onCancel
    });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      content: Container(
        width: 200,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Theme.of(context).colorScheme.onSecondary,
              hintText: 'Name new Group'
              ),
             
          ),
          TextField(
            controller: ammontController,
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Theme.of(context).colorScheme.onSecondary,
              hintText: 'ammount'
              ),
          ),
          Center(
            child: Row(
              children:[
              Button(text: 'Save', onPressed: onSave),
              const SizedBox(width: 10,),
              Button(text: 'cancel', onPressed: onCancel)
            
            ],),
          )
        ],),
      ),
    );
  }
}