import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controller.dart';

import '../../../../../../Controller/auth/auth_controller.dart';
import '../../../../../../Model/task.dart';
import '../../../../../../Util/Date/formatDate.dart';
import '../../../../../widgets/flutter_spinkit.dart';

class itemMessage extends StatelessWidget {
  itemMessage({
    super.key,
    required this.comment,
    required this.taskId,
    required this.taskItemId,
    required this.attachmentId,
  });

  final Item comment;
  final String taskId;
  final String taskItemId;
  final String attachmentId;
  int imagelanght = 0;
  int pdflanght = 0;
  int exllanght = 0;

  @override
  Widget build(BuildContext context) {
    comment.attachments.forEach((action) {
      if (imgFileTypes
          .any((type) => action["path"].toString().contains(type))) {
        imagelanght = imagelanght + 1;
      }
      if (pdfFileTypes
          .any((type) => action["path"].toString().contains(type))) {
        pdflanght = pdflanght + 1;
      }
      if (excelFileTypes
          .any((type) => action["path"].toString().contains(type))) {
        exllanght = exllanght + 1;
      }
    });
    print("imagelanght  " + imagelanght.toString());
    return GetBuilder<TaskController>(
        init: TaskController(),
        builder: (cont) {
          return Column(
            crossAxisAlignment:
                comment.creatorId == Get.put(AuthController()).user!.id
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              // Image.memory(cont.ListImage.first),

              InkWell(
                onTap: () {
                  Get.put(TaskController()).downloadfile(
                      taskId: taskId,
                      taskItemId: taskItemId,
                      attachmentId: attachmentId);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(comment.creatorId !=
                                    Get.put(AuthController()).user!.id
                                ? 0
                                : 15),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(comment.creatorId ==
                                    Get.put(AuthController()).user!.id
                                ? 0
                                : 15)),
                        color: comment.creatorId ==
                                Get.put(AuthController()).user!.id
                            ? Theme.of(context).primaryColor
                            : const Color.fromARGB(255, 231, 231, 231)),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: comment.creatorId ==
                                      Get.put(AuthController()).user!.id
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.start,
                              children: [
                                if (comment.creatorId !=
                                    Get.put(AuthController()).user!.id)
                                  Text(
                                    "@" + comment.creatorUsername,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                Text(
                                  comment.desc,
                                  style: TextStyle(
                                      color: comment.creatorId ==
                                              Get.put(AuthController()).user!.id
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14),
                                ),
                                Container(
                                    child: Row(
                                  children: [
                                    Text(comment.creatorId.toString()),
                                    Spacer(),
                                    Text(
                                      timeDifference(DateTime.parse(
                                          comment.createdAt.toString())),
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (comment.creatorId == Get.put(AuthController()).user!.id)
                    Spacer(),
                  Row(
                    children: [
                      if (imagelanght != 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/photo.png",
                                height: 17,
                              ),
                              Text(
                                imagelanght.toString(),
                                style: TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      if (pdflanght != 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/pdf.png",
                                height: 17,
                              ),
                              Text(
                                pdflanght.toString(),
                                style: TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      if (exllanght != 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/excel.png",
                                height: 17,
                              ),
                              Text(
                                exllanght.toString(),
                                style: TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(180),
                    child:
                        comment.creatorId != Get.put(AuthController()).user!.id
                            ? CircleAvatar(
                                radius: 10,
                                child: Center(
                                  child: Text(
                                    comment.creatorUsername[0],
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              )
                            : _imageMessage(comment),
                  ),
                ],
              ),
            ],
          );
        });
  }

  CachedNetworkImage _imageMessage(Item comment) {
    return CachedNetworkImage(
      imageUrl: Get.put(AuthController()).person!.img == null
          ? imageProfile
          : '${dotenv.get('urlHost')}/uploads/' +
              Get.put(AuthController()).person!.img.toString(),
      height: 20,
      width: 20,
      fit: BoxFit.cover,
      placeholder: (context, url) => spinkit,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

final imageProfile =
    'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg';
