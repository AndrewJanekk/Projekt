import 'package:flutter/material.dart';
import 'package:flutter_application_1/funcs/Grups.dart';
import 'package:flutter_application_1/funcs/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List GroupList = []; // 

  final _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true; 

  void CreateNewGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: _SaveNewGroup,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void _SaveNewGroup() {
    setState(() {
      GroupList.add([_controller.text]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void deleteGroup(int index) {
    setState(() {
      GroupList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ważne! Trzeba to wywołać w build() z AutomaticKeepAliveClientMixin.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      floatingActionButton: FloatingActionButton(
        onPressed: CreateNewGroup,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: ListView.builder(
        itemCount: GroupList.length,
        itemBuilder: (context, index) {
          return Grups(
            GroupName: GroupList[index][0],
            delateFunction: (context) => deleteGroup(index),
          );
        },
      ),
    );
  }
}
