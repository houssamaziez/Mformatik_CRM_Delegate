import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/annex_controller.dart';
import '../../../../Model/annex_model.dart';

class AnnexScreen extends StatelessWidget {
  final AnnexController annexController = Get.put(AnnexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annexes'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (annexController.isLoading.value) {
          return Center(child: spinkit);
        } else if (annexController.annexList.isEmpty) {
          return ListView(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(child: Text('Annexes'))),
            ],
          ).addRefreshIndicator(
              onRefresh: () => annexController.fetchAnnexes());
        } else {
          return ListView.builder(
            itemCount: annexController.annexList.length,
            itemBuilder: (context, index) {
              final AnnexModel annex = annexController.annexList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(annex.label),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: ${annex.user.username}'),
                      Text('Created: ${annex.createdAt}'),
                      Text('Updated: ${annex.updatedAt}'),
                      Text(
                          'User Active: ${annex.user.isActive ? "Yes" : "No"}'),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle tap
                  },
                ),
              );
            },
          ).addRefreshIndicator(
              onRefresh: () => annexController.fetchAnnexes());
        }
      }),
    );
  }
}
