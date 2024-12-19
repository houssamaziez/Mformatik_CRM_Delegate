import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';

import '../../../../../Controller/home/Person/controller_person.dart';
import '../../../../../Controller/home/Task/update_task_controller.dart';
import '../../../../../Controller/widgetsController/date_controller_create.dart';
import '../../../../../Model/user.dart';
import '../../../../../Util/Route/Go.dart';
import '../../persons/screen_list_persons.dart';
import 'widgets/selectDeadline.dart';

class EditeTaskOwner extends StatefulWidget {
  const EditeTaskOwner(
      {super.key,
      required this.libel,
      required this.responsible,
      this.observer,
      required this.deadling,
      required this.status,
      required this.taskId});
  final String libel;
  final Person responsible;
  final Person? observer;
  final DateTime? deadling;
  final int status;
  final int taskId;

  @override
  State<EditeTaskOwner> createState() => _EditeTaskOwnerState();
}

class _EditeTaskOwnerState extends State<EditeTaskOwner> {
  TextEditingController controllerdesc = TextEditingController();
  TextEditingController controllerLabel = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime? requestDate;

  bool isCompressImage = false;

  @override
  void dispose() {
    Get.delete<ControllerPerson>();
    Get.delete<DateControllerCreate>();
    super.dispose();
  }

  final ControllerPerson personController = Get.put(ControllerPerson());

  @override
  void initState() {
    controllerLabel.text = widget.libel;
    if (widget.deadling != null)
      Get.put(DateControllerCreate()).initDate(widget.deadling);

    personController.selectPersont(
        "Responsable",
        Person(
            id: widget.responsible.id,
            firstName: widget.responsible.firstName,
            lastName: widget.responsible.lastName,
            user: widget.responsible.user),
        isback: false);
    if (widget.observer != null) {
      personController.selectPersont(
        "observator",
        Person(
            id: widget.responsible.id,
            firstName: widget.observer!.firstName,
            lastName: widget.observer!.lastName,
            user: widget.observer!.user),
        isback: false,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edite Task".tr,
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
              if (widget.status == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Select Responsable".tr,
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
                            color: Colors.grey, // Border color
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
                                              ? "Select Responsable".tr
                                              : personController
                                                      .responsable!.firstName +
                                                  " " +
                                                  personController
                                                      .responsable!.firstName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                personController.responsable ==
                                                        null
                                                    ? Colors.grey
                                                    : Theme.of(context)
                                                        .primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              Text(
                "Select Observator".tr,
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
                      color: Colors.grey, // Border color
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
                                        ? "Select Observator".tr
                                        : personController
                                                .observator!.firstName +
                                            " " +
                                            personController
                                                .observator!.lastName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: personController.observator == null
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
              if (widget.status == 1)
                Text(
                  "Label".tr,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              if (widget.status == 1)
                const SizedBox(
                  height: 10,
                ),
              if (widget.status == 1)
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controllerLabel,
                        cursorColor:
                            Colors.grey, // Change the cursor color here
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Label".tr,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Label is required'.tr;
                          } else if (value.trim().length < 4) {
                            // Minimum length check
                            return 'Label must be at least 4 characters long'
                                .tr;
                          }
                          return null; // No error
                        },
                      ),
                    ],
                  ),
                ),
              Text(
                "Deadline".tr,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              selectDeadline(context),
              const SizedBox(
                height: 50,
              ),
              GetBuilder<UpdateTaskController>(
                  init: UpdateTaskController(),
                  builder: (updateTaskcontroller) {
                    return ButtonAll(
                      isloading: updateTaskcontroller.isLoading,
                      function: () {
                        if (widget.status == 1) {
                          if (_formKey.currentState!.validate()) {
                            updateTaskcontroller.updateTask(
                                taskID: widget.taskId,
                                label: controllerLabel.text,
                                responsibleId:
                                    personController.responsable!.user!.id,
                                deadline: Get.put(DateControllerCreate())
                                    .selectedDate,
                                observerId: personController.observator == null
                                    ? 0
                                    : personController.observator!.user!.id);
                          }
                        } else {
                          updateTaskcontroller.updateTask(
                              taskID: widget.taskId,
                              label: controllerLabel.text,
                              responsibleId:
                                  personController.responsable!.user!.id,
                              deadline:
                                  Get.put(DateControllerCreate()).selectedDate,
                              observerId: personController.observator == null
                                  ? 0
                                  : personController.observator!.user!.id);
                        }
                      },
                      title: "Update".tr,
                      color: Theme.of(context).primaryColor,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
