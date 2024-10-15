import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/home/missions_controller.dart';
import '../../../widgets/Containers/container_blue.dart';
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
    controller.getAllMission(context);
    _scrollController.addListener(_scrollListener);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.white,
      appBar: AppBar(
        title: Text('Missions'.tr),
        centerTitle: true,
      ),
      body: GetBuilder<MissionsController>(
        builder: (_) {
          if (controller.isLoading) {
            // Show a loading indicator while fetching data
            return const Center(
              child: spinkit,
            );
          } else if (controller.missions == null ||
              controller.missions!.isEmpty) {
            // Show a message when there are no missions
            return Center(
              child: Text(
                'No missions available'.tr,
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else {
            // Display the list of missions
            return Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: containerwithblue(
                            context,
                            height: 50,
                            widget: "data",
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.missions!.length,
                        itemBuilder: (context, index) {
                          final mission = controller.missions![index];
                          return MissionCard(mission: mission);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (controller.isLoadingMore) spinkit
                    ],
                  ).addRefreshIndicator(
                      onRefresh: () => controller.getAllMission(context)),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
