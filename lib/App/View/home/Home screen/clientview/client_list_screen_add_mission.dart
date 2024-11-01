import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/client_controller.dart';
import '../feedback/cretate_screen.dart';
import 'profile_client_screen.dart';

class ClientListScreenAddMission extends StatefulWidget {
  final String? companyid;
  final bool isback;
  final String role;
  ClientListScreenAddMission(
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
      await clientController.search(widget.companyid!, fullName: value);
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
              title: Text("Select the client"),
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
                hintText: "Search clients...",
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
                    'No clients available.',
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
                          Get.to(() => ClientProfileScreen(client: client));
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
                                  Icon(Icons.person, color: Colors.blueAccent),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      client.fullName ?? 'No Name',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
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
