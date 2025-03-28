import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

class ConnectivityController extends GetxController {
  var isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late Timer _checkInternetTimer;
  late bool _isDialogShowing;

  @override
  void onInit() {
    super.onInit();
    _isDialogShowing = false;

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _checkInternetStatus();
    });

    // Start periodic internet connectivity check
    _checkInternetTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkInternetStatus();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _checkInternetTimer.cancel();
    super.onClose();
  }

  Future<void> _checkInternetStatus() async {
    bool connected = await _hasInternetConnection();
    if (connected != isConnected) {
      isConnected = connected;
      update(); // Notify GetBuilder to rebuild
    }

    if (!connected && !_isDialogShowing) {
      _showNoInternetDialog();
    } else if (connected && _isDialogShowing) {
      Get.back(); // Close the dialog if internet is restored
      _isDialogShowing = false;
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://8.8.8.8')).timeout(
            const Duration(seconds: 5),
            onTimeout: () => http.Response('Error', 408),
          );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    _isDialogShowing = true;
    // Get.dialog(
    //   AlertDialog(
    //     title: Text('No internet connection'.tr),
    //     content: SizedBox(
    //       height: 160,
    //       child: Column(
    //         children: [
    //           Image.asset(
    //             'assets/icons/wi-fi.png',
    //             height: 110,
    //           ),
    //           Expanded(
    //               child: Text('Please check your internet connection.'.tr)),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Get.back(); // Close the dialog
    //           _isDialogShowing = false;
    //         },
    //         child: Text('Cancel'.tr,
    //             style: TextStyle(color: const Color.fromARGB(255, 0, 96, 174))),
    //       ),
    //       // TextButton(
    //       //   onPressed: () {
    //       //     _stopInternetCheck();
    //       //     Get.back(); // Close the dialog
    //       //     _isDialogShowing = false;
    //       //   },
    //       //   child: const Text('Complete in offline mode'),
    //       // ),
    //     ],
    //   ),
    //   barrierDismissible: false, // Prevent dialog dismissal by tapping outside
    // );

    showMessagetop(Get.context, title: "No internet connection");
    _isDialogShowing = false;
  }

//TODO:check this feature:
  void _stopInternetCheck() {
    _connectivitySubscription.cancel();
    _checkInternetTimer.cancel();
    isConnected = false;
    update(); // Notify GetBuilder to rebuild in offline mode
  }
}
