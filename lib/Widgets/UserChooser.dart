//Authors: Alexander Okrucký (xokruc00)


import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/User.dart';

class UserChooser extends StatefulWidget {
  UserChooser({super.key, required this.users, required this.controller});

  final UserChooserController controller;
  final List<OurUser> users;

  @override
  UserChooserState createState() => UserChooserState();
}

class UserChooserState extends State<UserChooser> {
  List<bool> checked = [];
  List<String> usersIds = [];
  List<OurUser> chosenUsers = [];

  @override
  void initState() {
    super.initState();
    widget.controller.getUserIds = getUserIds;
    widget.controller.getChosenUsers= getChosenUsers;
  }

  @override
  Widget build(BuildContext context) {
    if(checked.isEmpty) {
      checked = List.filled(widget.users.length, false);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: CheckboxListTile(
              value: checked[index],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                if(value!) {
                  setState(() {
                    checked[index] = value;
                    usersIds.add(widget.users[index].userId);
                    chosenUsers.add(widget.users[index]);
                  });
                } else {
                  setState(() {
                    checked[index] = value;
                    usersIds.remove(widget.users[index].userId);
                    chosenUsers.remove(widget.users[index]);
                  });
                }
              },
              title: Text(widget.users[index].username),
              checkColor: Colors.deepPurple[200],
            )
        );
      },
    );
  }

  List<String> getUserIds() {
    return usersIds;
  }

  List<OurUser> getChosenUsers() {
    return chosenUsers;
  }

}

class UserChooserController {
  late List<String> Function() getUserIds;
  late List<OurUser> Function() getChosenUsers;
}