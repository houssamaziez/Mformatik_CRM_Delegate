// company_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../../Controller/home/company_controller.dart';
import '../../../../../Util/Route/Go.dart';
import '../../../../../Util/Style/stylecontainer.dart';
import 'clientview/client_list_screen.dart';

class CompanyListScreen extends StatefulWidget {
  final String annexId;

  const CompanyListScreen({super.key, required this.annexId});
  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final CompanyController companyController = Get.put(CompanyController());
  @override
  void initState() {
    companyController.fetchCompanies(widget.annexId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companies'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (companyController.isLoading.value) {
          return Center(child: spinkit);
        }

        if (companyController.companies.isEmpty) {
          return Center(child: Text('No companies available.'));
        }

        return ListView.builder(
          itemCount: companyController.companies.length,
          itemBuilder: (context, index) {
            final company = companyController.companies[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: StyleContainer.style1,
                child: ListTile(
                  title: Text(company.label),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Company name: ${company.label}'),
                      Text('Created: ${company.createdAt}'),
                      Text('Updated: ${company.updatedAt}'),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Go.to(
                        context,
                        ClientListScreen(
                          companyid: company.id.toString(),
                          isback: true,
                        ));
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
