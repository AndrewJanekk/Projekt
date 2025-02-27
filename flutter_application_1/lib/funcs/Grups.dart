// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Grups extends StatelessWidget {
  final String GroupName;
  final double Money;
  Function(BuildContext)? delateFunction;
  Grups(
    {super.key,
    required this.GroupName,
    required this.delateFunction,
    required this.Money
    }
    );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: delateFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
            )
        ]),
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                GroupName,
                style: TextStyle(fontSize: 18),
                
              ),
              Text(
                 "${Money.toStringAsFixed(2)} zł",
                style: TextStyle(fontSize: 18),
              ),

              IconButton(onPressed: () {
                print('dodaj');
              },
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(Icons.add),
              iconSize: 25,
              ),
              
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]
          ),
          height: 200,
        ),
      ),
    );
  }

  static void add(List<String> list) {}
}