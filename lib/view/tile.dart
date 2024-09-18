// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:todolist_list/model/list.dart';
import '../utils/constant.dart';

class ToDoTile extends StatelessWidget {
  final ToDoList todolist;
  final void Function(ToDoList) handleIsDone;
  final handleDelete;
  const ToDoTile(
      {super.key, required this.todolist, required this.handleIsDone,required this.handleDelete});

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () => handleIsDone(todolist),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          todolist.taskName,
          style: TextStyle(
            height: 1,
              fontSize: 18,
              color: todolist.taskComplete? AppColor.iconBgColor : AppColor.color,
              fontWeight: FontWeight.w500,
              decoration: todolist.taskComplete ? TextDecoration.lineThrough : null),
        ),
        leading: todolist.taskComplete
            ? const Icon(
                Icons.check_box,
                color: AppColor.iconBgColor,
              )
            : const Icon(
                Icons.check_box_outline_blank,
                color: AppColor.color,
              ),
        trailing: Container(
            decoration: const BoxDecoration(
                color: AppColor.iconBgColor,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: ()=> handleDelete(todolist.taskId),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
