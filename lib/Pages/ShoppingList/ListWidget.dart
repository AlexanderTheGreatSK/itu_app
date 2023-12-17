///Author: Alena Klimecká - xklime47
import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/FamilyListPage.dart';
import 'package:itu_app/Pages/ShoppingList/ItemWidget.dart';

import '../../Database/DatabaseHandler.dart';
import 'AddItemWidget.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key, required this.list, required this.callback});
  final VoidCallback callback;
  final ShoppingList list;

  @override
  State<ListWidget> createState() => _ListWidget();
}

class _ListWidget extends State<ListWidget> {
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<bool> updateItems = ValueNotifier<bool>(false);
  bool isActive = false;
  bool isDeleting = false;
  bool addIsOpen = false;
  DatabaseHandler databaseHandler = DatabaseHandler();

  /// styl pro tlacitka uprav
  ButtonStyle smallButtonsStyle(Color backgroundColor) {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(15.0),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    );
  }

  @override

  /// vzhled a funkcionalita seznamu
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// vrchni cast s nazvem a ikonou tecek
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: InkWell(
            onTap: () {
              setState(() {
                isActive = !isActive;
                addIsOpen = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: isActive
                    ? const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))
                    : BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.list.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          elevation: 10,
                          showDragHandle: true,
                          backgroundColor: Colors.grey,
                          builder: (BuildContext context) {
                            return bottomBarWidget(context);
                          });
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// spodni cast otevrena po kliknuti
        if (isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  /// jednotlive polozky seznamu
                  ValueListenableBuilder<bool>(
                    valueListenable: updateItems,
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: databaseHandler
                            .getShoppingListByID(widget.list.shoppingListId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            ShoppingList listByID = snapshot.data!;
                            return ListView.builder(
                              itemCount: listByID.items.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ItemWidget(
                                  item: listByID.items[index],
                                  list: listByID,
                                  bought: false,
                                  callback: () {
                                    setState(() {
                                      updateItems.value = !updateItems.value;
                                    });
                                  },
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.deepPurpleAccent),
                            );
                          }
                        },
                      );
                    },
                  ),

                  /// ozavrena cast pro pridavani nove polozky
                  if (addIsOpen)
                    AddItemWidget(
                      list: widget.list,
                      callback: () {
                        setState(() {
                          updateItems.value = !updateItems.value;
                        });
                      },
                    ),

                  /// otevrena cast pro pridavani nove polozky
                  if (!addIsOpen)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              addIsOpen = true;
                            });
                          },
                          child: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 30,
                          )),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// okno pro smazani seznamu
  Widget deleteList(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text('Delete ${widget.list.name}?',
                  style: TextStyle(fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: smallButtonsStyle(Colors.grey),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      databaseHandler
                          .deleteShoppingList(widget.list.shoppingListId);
                      Navigator.pop(context);
                      widget.callback();
                    },
                    style: smallButtonsStyle(Colors.redAccent),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// okno pro prejmenovani seznamu
  Widget renameList(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nameController,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Name is empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'New name',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: smallButtonsStyle(Colors.grey),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (formKey.currentState!.validate()) {
                            widget.list.name = _nameController.text;
                            databaseHandler.updateShoppingList(widget.list);
                            Navigator.pop(context);
                            widget.callback();
                          }
                        });
                      },
                      style: smallButtonsStyle(Colors.green),
                      child: const Text('Rename',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// okno pro zmenu typu seznamu
  Widget updateList(BuildContext context) {
    List<String> list = <String>[
      'Grocery',
      'Pet shop',
      'Drugstore',
      'Hobby market',
      'Add my type'
    ];
    String dropdownValue = 'Grocery';

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                underline: Container(
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: (String? value) {
                  setState(() {
                    widget.list.type = value!;
                    dropdownValue = value;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: smallButtonsStyle(Colors.grey),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      databaseHandler.updateShoppingList(widget.list);
                      Navigator.pop(context);
                      widget.callback();
                    },
                    style: smallButtonsStyle(Colors.green),
                    child: const Text('Update',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// vyskakovaci obrazovka spodni casti - delete, update, change
  Widget bottomBarWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        /// rename
        InkWell(
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return renameList(context);
              },
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Text(
                "Rename",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),

        /// change category
        InkWell(
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return updateList(context);
              },
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.change_circle,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Text(
                "Change category",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),

        /// delete
        InkWell(
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return deleteList(context);
              },
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.delete_forever,
                  color: Color(0xFFD50000),
                  size: 35,
                ),
              ),
              Text(
                "Delete List",
                style: TextStyle(
                  color: Color(0xFFD50000),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
