import 'package:flutter/material.dart';

import '../../../../../../Controller/home/Task/task_controller.dart';
import 'item_message.dart';

class listItems extends StatelessWidget {
  final TaskController controller;
  const listItems({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
      ),
    );
  }
}
