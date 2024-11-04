import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/client_controller.dart';
import 'profile_client_screen.dart';

class ClientListScreen extends StatefulWidget {
  final String? companyid;
  final bool isback;
  ClientListScreen({super.key, this.companyid = "", required this.isback});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final ClientController clientController = Get.put(ClientController());
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  Timer? _debounce;

  @override
  void initState() {
    // clientController.fetchClients(widget.companyid!, fullName: '');
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

  // Method to handle search with debounce
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
              title: Text("All Clinets".tr),
              centerTitle: true,
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              // onChanged: (value) async {
              //   print(value);
              //   await clientController.search(widget.companyid!,
              //       fullName: value);

              //   selctserach = value;
              //   // Add search logic here if needed
              // },
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
                        Get.to(() => ClientProfileScreen(client: client));
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
