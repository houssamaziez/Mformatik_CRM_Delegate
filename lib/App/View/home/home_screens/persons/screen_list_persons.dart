import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/home/Person/controller_person.dart';

class ScreenListPersons extends StatefulWidget {
  final String tag;

  const ScreenListPersons({super.key, required this.tag});
  @override
  State<ScreenListPersons> createState() => _ScreenListPersonsState();
}

class _ScreenListPersonsState extends State<ScreenListPersons> {
  final ControllerPerson personController = Get.put(ControllerPerson());
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  Timer? _debounce;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      personController.fetchPersons();
      scrollController.addListener(_scrollListener);
    });
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
      if (!isLoadingMore && !personController.isLoading.value) {
        _loadMoreClients();
      }
    }
  }

  _loadMoreClients() {
    setState(() {
      isLoadingMore = true;
    });
    personController.fetchClientsaddOffset();
    setState(() {
      isLoadingMore = false;
    });
  }

  // Method to handle search with debounce
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () async {
      await personController.search(fullName: value.trim());
      setState(() {
        selctserach = value;
      });
    });
  }

  String selctserach = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Persons".tr),
        centerTitle: true,
      ),
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
                hintText: "Search Person...".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (personController.isLoading.value &&
                  personController.persons.isEmpty) {
                return Center(child: spinkit); // Initial loading indicator
              }

              if (personController.persons.isEmpty) {
                return Center(
                  child: Text(
                    'No Persons available.'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                itemCount:
                    personController.persons.length + (isLoadingMore ? 1 : 0),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  if (index == personController.persons.length) {
                    // Show circular indicator at the bottom when loading more
                    return Center(child: spinkit);
                  }

                  final person = personController.persons[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        personController.selectPersont(widget.tag, person);
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
                                      (person.firstName ?? 'No Name'.tr) +
                                              " " +
                                              person.lastName ??
                                          ''.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
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
