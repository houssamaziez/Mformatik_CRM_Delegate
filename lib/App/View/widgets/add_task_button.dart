import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/clientview/client_list_add_all/client_list_screen_add.dart';

import '../../Controller/home/company_controller.dart';
import '../../Util/Route/Go.dart';
import '../../Util/Style/Style/container/stylecontainer.dart';
import '../home/home_screens/home_task/createTask/create_tesk.dart';

class AddTaskbutton extends StatelessWidget {
  const AddTaskbutton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GetBuilder<CompanyController>(
            init: CompanyController(),
            builder: (companyController) {
              return InkWell(
                onTap: () {
                  Go.to(context, ScreenCreateTask());
                },
                child: Container(
                  decoration: StyleContainer.stylecontainer(
                      color: Theme.of(context).primaryColor),
                  child: Column(
                    children: [
                      const Spacer(),
                      Image.asset(
                        "assets/icons/addicon.png",
                        height: 32,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Add \n Task".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            }));
  }
}
