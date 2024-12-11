import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img; // For image compression
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/persons/screen_list_persons.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:vibration/vibration.dart';
// import 'package:voice_message_package/voice_message_package.dart';

import '../../../../../Controller/RecordController.dart';
import '../../../../../Controller/home/Person/controller_person.dart';
import '../../../../../Controller/widgetsController/date_controller_create.dart';
import '../../../../../Service/permission_handler/mic_handler.dart';
import '../../../../../Util/Const/constants.dart';
import '../task_details/profile_task.dart';
import 'widgets/selectDeadline.dart';
import 'widgets/select_file.dart';
import 'widgets/show_list_file.dart';

// ignore: must_be_immutable
class ScreenCreateTask extends StatefulWidget {
  ScreenCreateTask({super.key});

  @override
  State<ScreenCreateTask> createState() => _ScreenCreateTaskState();
}

class _ScreenCreateTaskState extends State<ScreenCreateTask> {
  TextEditingController controllerdesc = TextEditingController();
  TextEditingController controllerLabel = TextEditingController();
  final RecordController recordController = Get.put(RecordController());
  int reasonId = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  double? lat;
  double? lng;
  DateTime? requestDate;
  double _compressionProgress = 0.0;
  List<File>? _compressedImages = [];

  List<File> _selectedImages = []; // Store selected images
  List<File> _selectedFiles = []; // Store selected files
  bool isCompressImage = false;

  void _deleteFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      _compressedImages!.removeAt(index);
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles
            .addAll(result.files.map((file) => File(file.path!)).toList());
      });
    }
  }

  Future<File> _compressImage(XFile file) async {
    return File(file.path);
  }

  void _clearDate() {
    setState(() {
      _dateController.clear();
    });
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      File compressedImage = await _compressImage(photo);
      setState(() {
        _compressedImages!.add(compressedImage);
      });
    }
  }

  final TextEditingController _dateController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dateController.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> _selectImagesFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (int i = 0; i < pickedFiles.length; i++) {
        File compressedImage = await _compressImage(pickedFiles[i]);
        _compressedImages!.add(compressedImage);

        setState(() {
          _compressionProgress = ((i + 1) / pickedFiles.length) * 100;
        });
      }
      setState(() {
        _compressedImages = _compressedImages;
        _compressionProgress = 0.0;
      });
    }
  }

  @override
  void dispose() {
    Get.delete<ControllerPerson>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordController>(builder: (controllerVoice) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create Task",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Responsable",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Go.to(
                        context,
                        const ScreenListPersons(
                          tag: "Responsable",
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      border: Border.all(
                        color: Theme.of(context).primaryColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: GetBuilder<ControllerPerson>(
                                  init: ControllerPerson(),
                                  builder: (personController) {
                                    return Text(
                                      personController.responsable == null
                                          ? "Select Responsable"
                                          : personController
                                                  .responsable!.firstName +
                                              " " +
                                              personController
                                                  .responsable!.firstName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: personController.responsable ==
                                                null
                                            ? Colors.grey
                                            : Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(),
                            GetBuilder<ControllerPerson>(
                                init: ControllerPerson(),
                                builder: (personController) {
                                  return personController.responsable != null
                                      ? IconButton(
                                          onPressed: () {
                                            personController
                                                .closePerson("Responsable");
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                          ))
                                      : SizedBox.shrink();
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Observator",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Go.to(
                        context,
                        const ScreenListPersons(
                          tag: "Observator",
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      border: Border.all(
                        color: Theme.of(context).primaryColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: GetBuilder<ControllerPerson>(
                                  init: ControllerPerson(),
                                  builder: (personController) {
                                    return Text(
                                      personController.observator == null
                                          ? "Select Observator"
                                          : personController
                                                  .observator!.firstName +
                                              " " +
                                              personController
                                                  .observator!.lastName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: personController.observator ==
                                                null
                                            ? Colors.grey
                                            : Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(),
                            GetBuilder<ControllerPerson>(
                                init: ControllerPerson(),
                                builder: (personController) {
                                  return personController.observator != null
                                      ? IconButton(
                                          onPressed: () {
                                            personController
                                                .closePerson("Observator");
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                          ))
                                      : SizedBox.shrink();
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Label",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerLabel,
                  cursorColor: Theme.of(context)
                      .primaryColor, // Change the cursor color here
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Label",
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Label is required'.tr;
                    } else if (value.trim().length < 4) {
                      // Minimum length check
                      return 'Label must be at least 4 characters long'.tr;
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  minLines: 5, maxLength: 250, maxLines: 6,
                  controller: controllerdesc,
                  cursorColor: Theme.of(context)
                      .primaryColor, // Change the cursor color here
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required'.tr;
                    } else if (value.trim().length < 4) {
                      // Minimum length check
                      return 'Description must be at least 4 characters long'
                          .tr;
                    }
                    return null; // No error
                  },
                ),
                Text(
                  "Deadline",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                selectDeadline(context),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SelectFile(_selectImagesFromGallery, _takePhoto, _pickFile),
                if (_compressedImages!.isNotEmpty || _selectedFiles.isNotEmpty)
                  showfile(_compressedImages, _deleteImage, _selectedFiles,
                      _deleteFile),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetBuilder<TaskController>(
                      init: TaskController(),
                      builder: (taskController) {
                        return ButtonAll(
                            isloading: taskController.isLoadingCreate,
                            function: () {
                              List<String> listpathipdf = [];
                              List<String> listImage = [];
                              List<String> listExcel = [];

                              List<String> imagePaths = _compressedImages!
                                  .map((file) => file.path)
                                  .toList();

                              if (_selectedFiles != null) {
                                _selectedFiles.forEach((action) {
                                  if (imgFileTypes.any(
                                      (type) => action.path.contains(type))) {
                                    listImage.add(action.path.toString());
                                    print("The file is an image.");
                                  } else if (pdfFileTypes.any(
                                      (type) => action.path.contains(type))) {
                                    listpathipdf.add(action.path.toString());

                                    print("The file is a PDF.");
                                  } else if (excelFileTypes.any(
                                      (type) => action.path.contains(type))) {
                                    listExcel.add(action.path.toString());

                                    print("The file is an Excel document.");
                                  } else {
                                    print("Unknown file type.");
                                  }
                                });
                              } else {
                                print("Content-Type header is missing.");
                              }

                              taskController.createTask(
                                  label: controllerLabel.text,
                                  responsibleId: Get.put(ControllerPerson())
                                      .responsable!
                                      .user!
                                      .id
                                      .toString(),
                                  observerId:
                                      Get.put(ControllerPerson()).observator !=
                                              null
                                          ? Get.put(ControllerPerson())
                                              .observator!
                                              .user!
                                              .id
                                              .toString()
                                          : "",
                                  deadline: Get.put(DateControllerCreate())
                                          .selectedDate ??
                                      "",
                                  excelPaths: listExcel,
                                  pdfPaths: listpathipdf,
                                  imgPaths: imagePaths,
                                  itemDescription: controllerdesc.text);
                            },
                            title: 'add Task');
                      }),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
