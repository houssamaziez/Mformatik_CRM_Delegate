import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import 'dart:convert';
import '../../Model/annex_model.dart';
import '../auth/auth_controller.dart';

class AnnexController extends GetxController {
  var annexList = <AnnexModel>[].obs;
  var isLoading = true.obs;
  final String baseUrl = Endpoint.apiAnnexes;

  @override
  void onInit() {
    fetchAnnexes();
    super.onInit();
  }

  Future<void> fetchAnnexes() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl),
          headers: {"x-auth-token": token.read("token").toString()});

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        annexList.value =
            jsonResponse.map((data) => AnnexModel.fromJson(data)).toList();
      } else {
        showMessage(Get.context, title: "Failed to load annexes");
      }
    } catch (e) {
      showMessage(Get.context, title: 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }
}
