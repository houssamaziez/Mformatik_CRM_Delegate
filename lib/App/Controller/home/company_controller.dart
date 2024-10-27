// company_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Controller/home/client_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'dart:convert';
import '../../Model/company.dart';
import '../auth/auth_controller.dart';

class CompanyController extends GetxController {
  var companies = <Company>[].obs;
  var isLoading = false.obs;
  Company? selectCompany;

  Future<void> fetchCompanies(String id) async {
    companies.clear();
    selectCompany = null;
    update();
    try {
      isLoading.value = true;
      update();

      final response = await http.get(
        Uri.parse(Endpoint.apiCompanies).replace(
          queryParameters: {
            'annexId': id.toString(),
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        companies.value = responseData
            .map((item) => Company.fromJson(item))
            .toList()
            .cast<Company>();
        update();
      }
    } catch (e) {
      print("Error fetching companies: $e");
      isLoading.value = false;
      update();
    } finally {
      if (companies.isNotEmpty) {
        updateannex(companies.value.first);
      } else {
        print("object");
        clientController.search(0.toString(), fullName: '');

        companyController.getAllMission(Get.context, 0);

        print("No companies found.");
      }

      isLoading.value = false;
      update();
    }
    await clientController.search(selectCompany!.id.toString(), fullName: '');
  }

  MissionsController companyController = Get.put(MissionsController());
  ClientController clientController = Get.put(ClientController());

  updateannex(Company? selectAnnexvule) async {
    print(selectAnnexvule);
    selectCompany = selectAnnexvule;
    update();
    print(selectCompany!.id);
    companyController.getAllMission(Get.context, selectCompany!.id);
    await clientController.search(selectCompany!.id.toString(), fullName: '');
  }
}
