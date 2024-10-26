import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/supscreen/createmission/clientview/client_list_screen.dart';

import '../../../Controller/auth/auth_controller.dart';
import '../../../Controller/home/annex_controller.dart';
import '../../widgets/Bottombar/widgetbottombar.dart';
import '../../widgets/Containers/container_blue.dart';
import '../../widgets/bolck_screen.dart';
import '../Widgets/appbar_home.dart';
import '../homeview.dart';
import 'supscreen/createmission/annex_list_screen.dart';
import 'supscreen/profileUser/profile_user_screen.dart';
import 'supscreen/screenMissions/mission_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Get.put(MissionsController()).getAllMission(context );
    super.initState();
  }

  final List<Widget> _screen = [
    Home(),
    const MissionListScreen(),
    GetBuilder<CompanyController>(
        init: CompanyController(),
        builder: (cont) {
          return ClientListScreen(
            companyid: cont.selectCompany!.id.toString(),
            isback: false,
          );
        }),
    const ProfileUserScreen(),
  ];
  final MissionsController controller = Get.put(MissionsController());

  AuthController controllers = Get.put(AuthController());
  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          bool isactive = controllers.user!.isActive;
          return Scaffold(
            appBar: appbarHome(
              context,
            ),
            // bottomNavigationBar: buttonnavigationbar(context),
            body: isactive == true
                ? Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: controller.showContainers
                            ? 180
                            : 0, // Adjust height based on toggle
                        width: double.infinity,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: controller.showContainers
                                  ? 40
                                  : 0, // Adjust height based on toggle
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: "Select Annex :".style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: controller.showContainers
                                  ? 50
                                  : 0, // Adjust height based on toggle
                              width: double.infinity,
                              child: GetBuilder<AnnexController>(
                                  init: AnnexController(),
                                  builder: (annexController) {
                                    return annexController.isLoading.value
                                        ? Container()
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            // ignore: unnecessary_null_comparison
                                            itemCount:
                                                annexController.annexList ==
                                                        null
                                                    ? 0
                                                    : annexController
                                                        .annexList.length,
                                            itemBuilder: (context, index) {
                                              final annex = annexController
                                                  .annexList[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    annexController
                                                        .updateannex(annex);
                                                  },
                                                  child: containerwithblue(
                                                      context,
                                                      color:
                                                          annexController
                                                                      .selectAnnex !=
                                                                  annex
                                                              ? Theme.of(context)
                                                                  .primaryColor
                                                              : Colors.white,
                                                      backgColor: annexController
                                                                  .selectAnnex ==
                                                              annex
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.white,
                                                      widget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8),
                                                        child: Center(
                                                            child: annex.label.style(
                                                                color: annexController
                                                                            .selectAnnex !=
                                                                        annex
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : Colors
                                                                        .white)),
                                                      )),
                                                ),
                                              );
                                            });
                                  }),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: controller.showContainers
                                  ? 40
                                  : 0, // Adjust height based on toggle
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: "Select Company :".style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: controller.showContainers
                                  ? 50
                                  : 0, // Adjust height based on toggle
                              width: double.infinity,
                              child: GetBuilder<CompanyController>(
                                  init: CompanyController(),
                                  builder: (companyController) {
                                    print('----------');

                                    return companyController.isLoading.value
                                        ? Container()
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: companyController
                                                .companies.length,
                                            itemBuilder: (context, index) {
                                              final company = companyController
                                                  .companies[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    companyController
                                                        .updateannex(company);
                                                  },
                                                  child: containerwithblue(
                                                      context,
                                                      color: companyController
                                                                  .selectCompany !=
                                                              company
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.white,
                                                      backgColor: companyController
                                                                  .selectCompany ==
                                                              company
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.white,
                                                      widget: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8),
                                                        child: Center(
                                                            child: company.label.style(
                                                                color: companyController
                                                                            .selectCompany !=
                                                                        company
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : Colors
                                                                        .white)),
                                                      )),
                                                ),
                                              );
                                            });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _screen[controller.indexBottomBar]),
                    ],
                  )
                : const screenBlock(),
          );
        });
  }
}
