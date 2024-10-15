import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/annex_model.dart';

class AnnexController extends GetxController {
  var annexList = <AnnexModel>[].obs;
  var isLoading = true.obs;
  final String baseUrl = "{{baseUrl}}/v1/annexes";

  @override
  void onInit() {
    fetchAnnexes();
    super.onInit();
  }

  Future<void> fetchAnnexes() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        annexList.value =
            jsonResponse.map((data) => AnnexModel.fromJson(data)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load annexes');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }
}
