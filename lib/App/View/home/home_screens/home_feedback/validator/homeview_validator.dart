import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';

import '../../../../../Controller/home/annex_controller.dart';
import '../../../../../Controller/home/company_controller.dart';
import '../../../../../Controller/home/home_controller.dart';
import '../../../../../Util/Style/stylecontainer.dart';
import '../../../../widgets/flutter_spinkit.dart';
import '../../../Widgets/filter_annex_company.dart';

Widget buildLoadingCompanySection(HomeController controller) {
  return SingleChildScrollView(
    child: Column(
      children: [
        FilterCompany(controller: controller),
        const SizedBox(height: 150),
        const Center(child: spinkit),
      ],
    ),
  );
}

Widget buildNoCompanyFoundSection(context, HomeController controller,
    CompanyController companyController, String title) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Column(
      children: [
        FilterCompany(controller: controller),
        const SizedBox(height: 200),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.tr,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controllerHome) {
              return controllerHome.showContainers == false
                  ? InkWell(
                      onTap: () {
                        Get.put(HomeController()).upadteshowcontaner();
                      },
                      child: Container(
                        decoration: StyleContainer.stylecontainer(
                            color: Theme.of(context).primaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              "Select another annex".style(color: Colors.white),
                        ),
                      ),
                    )
                  : Container();
            }),
        const SizedBox(height: 200),
      ],
    ),
  ).addRefreshIndicator(
    onRefresh: () => Get.put(AnnexController()).fetchAnnexes().then((_) {
      companyController.updateannex(Get.put(CompanyController()).selectCompany);
    }),
  );
}
