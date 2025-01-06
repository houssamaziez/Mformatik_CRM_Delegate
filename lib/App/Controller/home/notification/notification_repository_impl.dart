// import 'dart:convert';

// import '../../../model/feed_back.dart';
// import '../../../model/in_app_notification_model.dart';
// import '../../../model/mission.dart';
// import '../../../model/web_socket_notifcation_model.dart';
// import '../../../model/reason.dart';
// import '../../../utils/app_exceptions/response_handler.dart';
// import 'package:http/http.dart' as http;

// import '../../../utils/shared_prefs.dart';
// import '../../../utils/urls.dart';

// import 'notification_repository.dart';

// class NotificationRepository implements INotificationRepository {
//   late Map<String, String> _headers;

//   NotificationRepository({required String token}) {
//     _headers = {
//       'Accept-Language': Prefs.getString(SPKeys.language) ?? 'en',
//       'Content-Type': 'application/json',
//       'x-auth-token': token
//     };
//   }

//   @override
//   Future<List<InAppNotificationModel>> getNotifications() async {
//     final response = await http.get(Uri.parse(Urls.notifications), headers: _headers);
//     final parsed = ResponseHandler.processResponse(response);

//     return (parsed['rows'] as List).map((json) => InAppNotificationModel.fromJson(json)).toList();
//   }

//   @override
//   Future<void> editNotificationStatus({required int notificationId, required int status}) async {
//     final response = await http.put(Uri.parse('${Urls.notifications}/$notificationId/to/$status'), headers: _headers);
//     await ResponseHandler.processResponse(response);
//   }

//   @override
//   Future<void> editNotificationsBulkStatus({required List<int> notificationsIdsList, required int status}) async {
//     final uri = Uri.parse('${Urls.notifications}/$status');
//     final response = await http.put(
//       uri,
//       headers: _headers,
//       body: jsonEncode({
//         'id': notificationsIdsList,
//       }),
//     );
//     await ResponseHandler.processResponse(response);
//   }
// }
