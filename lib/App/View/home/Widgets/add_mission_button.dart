import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/home/company_controller.dart';
import '../../../Util/Route/Go.dart';
import '../../../Util/Style/stylecontainer.dart';
import '../Home screen/supscreen/createmission/clientview/client_list_screen.dart';

class AddMissionbutton extends StatelessWidget {
  const AddMissionbutton({
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
                      ClientListScreen(
                        companyid:
                            companyController.selectCompany!.id.toString(),
                        isback: true,
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
                      const Text(
                        "Add \n Mission",
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
