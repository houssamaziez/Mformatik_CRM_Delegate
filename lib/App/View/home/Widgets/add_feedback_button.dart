import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/home/company_controller.dart';
import '../../../Util/Route/Go.dart';
import '../../../Util/Style/stylecontainer.dart';
import '../home_screens/clientview/client_list_add_all/client_list_screen_add.dart';

class AddMissionbuttonFeddback extends StatelessWidget {
  const AddMissionbuttonFeddback({
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
                  Go.to(
                      context,
                      ClientListScreenAddMission(
                        companyid:
                            companyController.selectCompany!.id.toString(),
                        isback: true,
                        role: 'feedback',
                      ));
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
                        "Add \n Feedback".tr,
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
