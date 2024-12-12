// company_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Controller/home/client_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/feedback/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/mission/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
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
      if (id == "0".toString()) {
        showMessage(Get.context, title: "No companies found.");
        return;
      }
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
        // ignore: invalid_use_of_protected_member
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
  FeedbackController feedbackController = Get.put(
    FeedbackController(),
  );
  ClientController clientController = Get.put(ClientController());

  updateannex(Company? selectAnnexvule) async {
    print(selectAnnexvule);
    selectCompany = selectAnnexvule;
    update();
    print(selectCompany!.id);
    companyController.getAllMission(Get.context, selectCompany!.id);
    Get.put(
      FeedbackController(),
    ).fetchFeedbacks(selectCompany!.id.toString(),
        Get.put(AuthController()).user!.id.toString());
    await clientController.search(selectCompany!.id.toString(), fullName: '');
  }

  Future<void> updateCompanies(String id) async {
    try {
      if (id == "0".toString()) {
        showMessage(Get.context, title: "No companies found.");
        return;
      }
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
    } finally {}
  }
}
