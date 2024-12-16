import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/Task/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Lanch_url/select_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/widgets/ShowPDFs.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/widgets/showimage.dart';

import '../../../../../../Controller/auth/auth_controller.dart';
import '../../../../../../Model/task_models/item_task.dart';
import '../../../../../../Model/task_models/task.dart';
import '../../../../../../Util/Date/formatDate.dart';
import '../../../../../../Util/extention/file.dart';
import 'profile_image.dart';

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
  List<FileModel> listitem = [];
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
      listitem
          .add(FileModel(name: action["path"], id: action["id"].toString()));
    });

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
                padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: comment.creatorId ==
                              Get.put(AuthController()).user!.id
                          ? Theme.of(context).primaryColor.withOpacity(0.5)
                          : Colors.grey,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "@" + comment.creatorUsername,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                    timeDifference(DateTime.parse(
                                        comment.createdAt.toString())),
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: InteractiveTextScreen(
                                    description: comment.desc),
                              ),
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
                                                taskItemId:
                                                    comment.id.toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Color(0xffcfcff6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/icons/photo.png",
                                                  height: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              imagelanght.toString(),
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
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
                                                extention: "pdf",
                                                name: pdfpath,
                                                listitem: listitem,
                                                taskId: taskId,
                                                taskItemId:
                                                    comment.id.toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Color(0xffcfcff6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/icons/pdf.png",
                                                  height: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              pdflanght.toString(),
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
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
                                            ShowPDFs(
                                                extention: "xlsx",
                                                name: exllpath,
                                                listitem: listitem,
                                                taskId: taskId,
                                                taskItemId:
                                                    comment.id.toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Color(0xffcfcff6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/icons/excel.png",
                                                  height: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              exllanght.toString(),
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _profileimage(),
            ],
          );
        });
  }

  Row _profileimage() {
    return Row(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: comment.creatorId != Get.put(AuthController()).user!.id
                  ? CircleAvatar(
                      radius: 10,
                      child: Center(
                        child: Text(
                          comment.creatorUsername[0],
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: comment.creatorId != Get.put(AuthController()).user!.id
              ? Container()
              : imageMessage(comment),
        ),
      ],
    );
  }
}
