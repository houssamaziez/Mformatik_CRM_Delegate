// company_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'dart:convert';
import '../../Model/company.dart';
import '../auth/auth_controller.dart';

class CompanyController extends GetxController {
  var companies = <Company>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCompanies(String id) async {
    try {
      isLoading.value = true;
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
      } else {
        throw Exception('Failed to load companies');
      }
    } catch (e) {
      print("Error fetching companies: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
