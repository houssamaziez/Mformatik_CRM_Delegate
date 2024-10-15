import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;

import '../../Model/mission.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../View/widgets/showsnack.dart';
import '../auth/auth_controller.dart';

class MissionsController extends GetxController {
  Uri url = Uri.parse(Endpoint.apiMissions);
  List<Mission>? rows;
  bool isLoading = false;

  Future<void> getAllMission(
    context,
  ) async {
    Uri url = Uri.parse(Endpoint.apIme);

    isLoading = true; // Set loading state
    update();
    try {
      final response = await http
          .get(url, headers: {"x-auth-token": token.read("token").toString()});
      print(response.body);
      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        rows = MissionResponse.fromJson(responseData).rows;
        print(rows!.first
            .creatorUsername); // user = User.fromJson(responseData['user']);
      } else {}
    } catch (e) {
      // Handle exceptions
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }
}
