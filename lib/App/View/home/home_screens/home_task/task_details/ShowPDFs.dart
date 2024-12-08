import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/convert/convert_bytes.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/ShowExcel.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../Controller/home/task_controller.dart';
import '../../../../widgets/flutter_spinkit.dart';

class ShowPDFs extends StatefulWidget {
  const ShowPDFs({
    super.key,
    required this.listitem,
    required this.taskId,
    required this.taskItemId,
    required this.name,
  });
  final List name;
  final List<PdfModel> listitem;
  final String taskId, taskItemId;

  @override
  State<ShowPDFs> createState() => _ShowPDFsState();
}

class _ShowPDFsState extends State<ShowPDFs> {
  bool islaoding = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskController = Get.put(TaskController());
      taskController.cleanListPDF();
      setState(() {
        islaoding = true;
      });

      setState(() {
        islaoding = false;
      });
    });
  }

  void _showPDFFullScreen(Uint8List pdfBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPDF(pdfBytes: pdfBytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Gallery'),
        centerTitle: true,
      ),
      body: GetBuilder<TaskController>(
        init: TaskController(),
        builder: (taskController) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: widget.name.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8.0)),
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/pdf.png",
                                height: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  extractFileName(
                                    widget.listitem[index].name,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () async {
                              widget.listitem[index] = widget.listitem[index]
                                  .copyWith(isdownload: true);

                              final Uint8List ff =
                                  await taskController.downloadFileStream(
                                      taskId: widget.taskId,
                                      taskItemId: widget.taskItemId,
                                      attachmentId: widget.listitem[index].id,
                                      index: index,
                                      name: extractFileName(
                                        widget.listitem[index].name,
                                      ));
                              widget.listitem[index] = widget.listitem[index]
                                  .copyWith(isdownload: false);
                              widget.listitem[index] =
                                  widget.listitem[index].copyWith(baytes: ff);
                            },
                            icon: taskController.totalBytes == 0 ||
                                    index != taskController.downloadselect
                                ? const Icon(Icons.download)
                                : Text(
                                    convertBytes(taskController.totalBytes),
                                  ))
                      ],
                    ),
                    // child: GestureDetector(
                    //   onTap: () async {
                    //     widget.listitem[index] =
                    //         widget.listitem[index].copyWith(isdownload: true);

                    //     final Uint8List ff =
                    //         await taskController.downloadfilereturn(
                    //             taskId: widget.taskId,
                    //             taskItemId: widget.taskItemId,
                    //             attachmentId: widget.listitem[index].id,
                    //             name: extractFileName(
                    //               widget.listitem[index].name,
                    //             ));
                    //     widget.listitem[index] =
                    //         widget.listitem[index].copyWith(isdownload: false);
                    //     widget.listitem[index] =
                    //         widget.listitem[index].copyWith(baytes: ff);
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black.withOpacity(0.1),
                    //           blurRadius: 5,
                    //           offset: const Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Expanded(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Image.asset(
                    //                 widget.listitem[index].isdownload == false
                    //                     ? "assets/icons/pdf.png"
                    //                     : "assets/icons/download.gif"),
                    //           ),
                    //         ),
                    //         // Text indicating if the file has been downloaded
                    //         Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                   extractFileName(
                    //                     widget.listitem[index].name,
                    //                   ),
                    //                   overflow: TextOverflow.ellipsis,
                    //                   maxLines: 1,
                    //                   style: TextStyle(fontSize: 12),
                    //                 ),
                    //                 // Conditionally show "Downloaded" text if bytes are present
                    //                 if (widget.listitem[index].baytes != null &&
                    //                         widget.listitem[index].baytes!
                    //                             .isNotEmpty ||
                    //                     fileCache.containsKey(
                    //                         '${widget.taskId}-${widget.taskItemId}-${widget.listitem[index].id}'))
                    //                   Padding(
                    //                     padding:
                    //                         const EdgeInsets.only(top: 4.0),
                    //                     child: Text(
                    //                       'Downloaded',
                    //                       style: TextStyle(
                    //                         fontSize: 10,
                    //                         color: Colors.green,
                    //                       ),
                    //                     ),
                    //                   ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FullScreenPDF extends StatelessWidget {
  final Uint8List pdfBytes;

  const FullScreenPDF({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}

class PdfModel {
  final String name;
  final String id;
  final bool isdownload;
  final Uint8List? baytes;

  PdfModel({
    this.baytes,
    required this.name,
    required this.id,
    this.isdownload = false,
  });

  PdfModel copyWith({
    Uint8List? baytes,
    bool? isdownload,
  }) {
    return PdfModel(
      name: name ?? this.name,
      baytes: baytes ?? this.baytes,
      id: id ?? this.id,
      isdownload: isdownload ?? this.isdownload,
    );
  }
}
