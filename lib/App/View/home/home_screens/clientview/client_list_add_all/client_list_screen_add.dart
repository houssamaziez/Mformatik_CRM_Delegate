import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_feedback/create_feedback/cretate_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../../Controller/home/client_controller.dart';

import '../../home_mission/createmission/cretate_screen.dart';
import '../profile_client_screen.dart';

class ClientListScreenAddMission extends StatefulWidget {
  final String? companyid;
  final bool isback;
  final String role;
  const ClientListScreenAddMission(
      {super.key,
      this.companyid = "",
      required this.isback,
      required this.role});

  @override
  State<ClientListScreenAddMission> createState() =>
      _ClientListScreenAddMissionState();
}

class _ClientListScreenAddMissionState
    extends State<ClientListScreenAddMission> {
  final ClientController clientController = Get.put(ClientController());
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    clientController.fetchClients(widget.companyid!, fullName: '');
    _onSearchChanged("");
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      // Load more data when reaching near the bottom
      if (!isLoadingMore && !clientController.isLoading.value) {
        _loadMoreClients();
      }
    }
  }

  Future<void> _loadMoreClients() async {
    setState(() {
      isLoadingMore = true;
    });
    await clientController.fetchClientsaddOffset(widget.companyid!,
        fullName: '');
    setState(() {
      isLoadingMore = false;
    });
  }

  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () async {
      await clientController.search(widget.companyid!, fullName: value.trim());
      setState(() {
        selctserach = value;
      });
    });
  }

  String selctserach = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isback
          ? AppBar(
              title: Text("Select the client".tr),
              centerTitle: true,
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search clients...".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (clientController.isLoading.value &&
                  clientController.clients.isEmpty) {
                return Center(child: spinkit); // Initial loading indicator
              }

              if (clientController.clients.isEmpty) {
                return Center(
                  child: Text(
                    'No clients available.'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                itemCount:
                    clientController.clients.length + (isLoadingMore ? 1 : 0),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  if (index == clientController.clients.length) {
                    // Show circular indicator at the bottom when loading more
                    return Center(child: spinkit);
                  }

                  final client = clientController.clients[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (widget.role == "mission") {
                          Get.to(
                              () => CreateMissionScreen(clientID: client.id!));
                          // Get.to(() => ClientProfileScreen(client: client));
                        } else {
                          Get.to(() => CreateFeedBackScreen(
                                clientID: client.id!,
                                missionID: null,
                                feedbackModelID: 0,
                              ));
                        }
                      },
                      child: Container(
                        decoration: StyleContainer.style1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      client.fullName ?? 'No Name'.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    client.tel ?? 'N/A',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.phone_android_rounded,
                                      size: 15, color: Colors.green),
                                  SizedBox(width: 10),
                                  Text(
                                    client.phone ?? 'N/A',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Colors.redAccent,
                                    size: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    client.email ?? 'No Email'.tr,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sold:'.tr + " ${client.sold}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Potential:'.tr + " ${client.potential}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Turnover:'.tr + " ${client.sold}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Cashing In:'.tr + " ${client.potential}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
