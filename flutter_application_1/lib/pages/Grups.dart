import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class Groups extends StatefulWidget {
  final String groupName;
  final double totalAmount;
  final String groupId;
  final Function(BuildContext)? deleteFunction;
  final Function(String groupId) onAddMember;

  const Groups({
    super.key,
    required this.groupName,
    required this.deleteFunction,
    required this.totalAmount,
    required this.groupId,
    required this.onAddMember,
  });

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  List<Map<String, dynamic>> _members = [];
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final members =
          await _authService.getGroupMembers(int.parse(widget.groupId));
      setState(() {
        _members = members;
      });
    } catch (e) {
      print("Błąd ładowania członków: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: widget.deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
          )
        ]),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.groupName, style: const TextStyle(fontSize: 18)),
                  Text("${widget.totalAmount.toStringAsFixed(2)} zł",
                      style: const TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () => widget.onAddMember(widget.groupId),
                    icon: const Icon(Icons.add),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _members.isEmpty
                    ? const Center(child: Text("Brak członków"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _members.length,
                        itemBuilder: (context, index) {
                          final member = _members[index]['profiles'];
                          return ListTile(
                            title: Text(member['username'] ?? 'Nieznany'),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
