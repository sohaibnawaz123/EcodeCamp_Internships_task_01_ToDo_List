// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_list/controller/databaseController.dart';
import 'package:todolist_list/model/list.dart';
import 'package:todolist_list/view/tile.dart';
import '../utils/constant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Databasecontroller databasecontroller = Get.put(Databasecontroller());
  final FocusNode addtaskNode = FocusNode();
  TextEditingController addtask = TextEditingController();
  List<Map<String, dynamic>> journals = [];

  @override
  void initState() {
    super.initState();
    reFreshJournal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
          toolbarHeight: 100,
          elevation: 0,
          backgroundColor: AppColor.bgColor,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.menu,
                color: AppColor.iconColor,
                size: 50,
              ),
              Text(
                'Ecode-Camp',
                style: TextStyle(
                    fontSize: 32,
                    shadows: [
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 3))
                    ],
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmDTGoPrHD82E1vnlWU19K--V55YPcipEYCP7jtv5rtKf2eV2bqUt_F-6cq79Zl7l7Oj8&usqp=CAU',
                    scale: 10),
              )
            ],
          )),
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height / 10,
                    decoration: const BoxDecoration(
                      color: AppColor.bgColor,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        'ToDo List',
                        style: TextStyle(
                            fontSize: 40,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 10,
                                  offset: Offset(0, 3))
                            ],
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                            itemCount: journals.length,
                            itemBuilder: (context, index) {
                              bool taskComplete =
                                  journals[index]['taskComplete'] == 1;
                              ToDoList todo = ToDoList(
                                  taskId: journals[index]['taskId'],
                                  taskName: journals[index]['taskName'],
                                  taskComplete: taskComplete);
                              return ToDoTile(
                                  todolist: todo,
                                  handleIsDone: _handleToDone,
                                  handleDelete: deleteItem);
                            })),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: Get.width,
              height: Get.height / 10,
              decoration: const BoxDecoration(
                  color: AppColor.bgColor,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 0,
                        color: Colors.grey,
                        offset: Offset(0, -5)),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: addtask,
                      focusNode: addtaskNode,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Add Task",
                        hintStyle:
                            TextStyle(fontSize: 20, color: AppColor.textColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(60, 60),
                            maximumSize: const Size(60, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppColor.color),
                        onPressed: () {
                          saveTask();
                        },
                        child: const Text(
                          '+',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void reFreshJournal() async {
    final data = await databasecontroller.readData();
    setState(() {
      journals = data;
    });
  }

  void _handleToDone(ToDoList todo) async {
    setState(() {
      todo.taskComplete = !todo.taskComplete;
    });
    await databasecontroller.updateTaskInDatabase(todo);
    reFreshJournal();
  }

  void saveTask() async {
    if (addtask.text.isEmpty) {
      Get.snackbar('Error', "Please! Write some thing",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.iconBgColor,
          colorText: AppColor.textColor,
          snackStyle: SnackStyle.FLOATING);
    } else {
      ToDoList todo = ToDoList(
        taskId: DateTime.now().microsecondsSinceEpoch.toString(),
        taskName: addtask.text,
      );
      await databasecontroller.insertData(todo.toMap());
      addtask.clear();
      addtaskNode.unfocus();
      reFreshJournal();
    }
  }

  void deleteItem(String id) async {
    await databasecontroller.deleteData(id);
    reFreshJournal();
  }
}
