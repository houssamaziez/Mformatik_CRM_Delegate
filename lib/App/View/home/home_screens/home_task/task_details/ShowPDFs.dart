import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final List listitem;
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
      widget.listitem.forEach((action) {
        taskController.downloadfile(
          taskId: widget.taskId,
          taskItemId: widget.taskItemId,
          attachmentId: action["id"].toString(),
        );
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
          if (taskController.ListPDF.isEmpty) {
            return const Center(
              child: spinkit,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two PDFs per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.name.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      _showPDFFullScreen(taskController.ListPDF[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: taskController.ListPDF.length > index
                        ? Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/icons/pdf.png"),
                                ),
                              ), // Show spinkit when the index is out of range
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    extractFileName(
                                      widget.name.isNotEmpty &&
                                              widget.name.length > index
                                          ? widget.name[index]
                                          : "",
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          )
                        : spinkit,
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
