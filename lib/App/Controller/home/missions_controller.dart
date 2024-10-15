import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;

import '../../Model/mission.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../View/widgets/showsnack.dart';
import '../auth/auth_controller.dart';

class MissionsController extends GetxController {
  List<Mission>? missions;
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0;
  final int limit = 5;
  Future<void> getAllMission(
    context,
  ) async {
    offset = 0;
    final uri =
        Uri.parse('${Endpoint.apiMissions}?offset=$offset&limit=$limit');

    isLoading = true; // Set loading state
    update();
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);
      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        missions = MissionResponse.fromJson(responseData).rows;
        // user = User.fromJson(responseData['user']);
      } else {}
    } catch (e) {
      // Handle exceptions
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }

  Future<void> loadingMoreMission(
    context,
  ) async {
    isLoadingMore = true;
    offset = limit + offset;

    final uri =
        Uri.parse('${Endpoint.apiMissions}?offset=$offset&limit=$limit');
    update();
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);
      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        missions!.addAll(MissionResponse.fromJson(responseData).rows);
        print(missions!.first
            .creatorUsername); // user = User.fromJson(responseData['user']);
      }
    } catch (e) {
      offset = limit - offset;
      isLoadingMore = false; // Reset loading state
      update();
      // Handle exceptions
      // showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoadingMore = false; // Reset loading state
      update();
    }
  }
}
