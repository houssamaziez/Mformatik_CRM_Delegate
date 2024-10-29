import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Controller/home/annex_controller.dart';
import '../../../../Controller/home/missions_controller.dart';
import '../../../widgets/Buttons/meneuSelectTow.dart';
import '../../../widgets/Containers/container_blue.dart';
import '../../../widgets/bolck_screen.dart';
import '../clientview/client_list_screen.dart';
import 'widgets/mission_card.dart';

class MissionListScreen extends StatefulWidget {
  const MissionListScreen({Key? key}) : super(key: key);

  @override
  State<MissionListScreen> createState() => _MissionListScreenState();
}

class _MissionListScreenState extends State<MissionListScreen> {
  // Initialize the MissionsController
  final MissionsController controller = Get.put(MissionsController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // controller.getAllMission(context);
    // _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !controller.isLoadingMore) {
      controller.loadingMoreMission(
        context,
      );
    }
  }

  AuthController controllers = Get.put(AuthController());
  bool _showContainers = false;
  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    bool isactive = controllers.user!.isActive;
    return isactive == true
        ? Scaffold(
            appBar: AppBar(
              title: Text("All Missions"),
              centerTitle: true,
            ),
            backgroundColor: ColorsApp.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GetBuilder<MissionsController>(
                    builder: (_) {
                      if (controller.isLoading) {
                        // Show a loading indicator while fetching data
                        return const Center(
                          child: spinkit,
                        );
                      } else if (controller.missionsfilter == null ||
                          controller.missionsfilter!.isEmpty) {
                        // Show a message when there are no missions
                        return Column(
                          children: [
                            SizedBox(
                                child: meneuSelectTow(context,
                                    indexchos: controller.indexminu,
                                    onIndexChanged: (p0) {
                              controller.onIndexChanged(p0);
                            }, titles: ["From Platform", "By me"])),
                            const Spacer(),
                            Center(
                              child: Text(
                                'No missions available'.tr,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const Spacer(),
                          ],
                        );
                      } else {
                        // Display the list of missions
                        return Column(
                          children: [
                            SizedBox(
                                child: meneuSelectTow(context,
                                    indexchos: controller.indexminu,
                                    onIndexChanged: (p0) {
                              controller.onIndexChanged(p0);
                            }, titles: ["Platform", "By me"])),
                            Expanded(
                                child: ListView(
                              controller: _scrollController,
                              shrinkWrap: true,
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.missionsfilter!.length,
                                  itemBuilder: (context, index) {
                                    final mission =
                                        controller.missionsfilter![index];
                                    return MissionCard(mission: mission);
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (controller.isLoadingMore) spinkit
                              ],
                            )

                                // .addRefreshIndicator(
                                //     onRefresh: () =>
                                //         controller.getAllMission(context)),
                                ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        : const screenBlock();
  }
}
