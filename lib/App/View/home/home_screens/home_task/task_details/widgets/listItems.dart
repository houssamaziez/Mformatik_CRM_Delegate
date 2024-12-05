import 'package:flutter/material.dart';

import '../../../../../../Controller/home/task_controller.dart';
import 'item_message.dart';

class listItems extends StatelessWidget {
  final TaskController controller;
  const listItems({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 247, 247, 247),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.task!.items.length,
                itemBuilder: (context, indext) {
                  final comment = controller.task!.items[indext];
                  return itemMessage(
                    comment: comment,
                    taskId: controller.task!.id.toString(),
                    taskItemId: controller.task!.items[indext].id.toString(),
                  );
                }),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
