import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/ShowExcel.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/ShowPDFs.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/showfile.dart';

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
  });

  final Item comment;
  final String taskId;
  final String taskItemId;
  int imagelanght = 0;
  List imagepath = [];
  int pdflanght = 0;
  List pdfpath = [];

  int exllanght = 0;
  List exllpath = [];

  @override
  Widget build(BuildContext context) {
    comment.attachments.forEach((action) {
      if (imgFileTypes
          .any((type) => action["path"].toString().contains(type))) {
        imagelanght = imagelanght + 1;
        imagepath.add(action["path"].toString());
      }
      if (pdfFileTypes
          .any((type) => action["path"].toString().contains(type))) {
        pdflanght = pdflanght + 1;
        pdfpath.add(action["path"].toString());
      }
      if (excelFileTypes
          .any((type) => action["path"].toString().contains(type))) {
        exllanght = exllanght + 1;
        exllpath.add(action["path"].toString());
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

              Padding(
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
              Row(
                children: [
                  if (comment.creatorId == Get.put(AuthController()).user!.id)
                    Spacer(),
                  Row(
                    children: [
                      if (imagelanght != 0)
                        InkWell(
                          onTap: () {
                            Go.to(
                                context,
                                ShowImages(
                                    listitem: comment.attachments,
                                    taskId: taskId,
                                    taskItemId: comment.id.toString()));
                          },
                          child: Padding(
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
                        ),
                      if (pdflanght != 0)
                        InkWell(
                          onTap: () {
                            Go.to(
                                context,
                                ShowPDFs(
                                    name: pdfpath,
                                    listitem: comment.attachments,
                                    taskId: taskId,
                                    taskItemId: comment.id.toString()));
                          },
                          child: Padding(
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
                        ),
                      if (exllanght != 0)
                        InkWell(
                          onTap: () {
                            Go.to(
                                context,
                                ShowExcel(
                                    name: exllpath,
                                    listitem: comment.attachments,
                                    taskId: taskId,
                                    taskItemId: comment.id.toString()));
                          },
                          child: Padding(
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
