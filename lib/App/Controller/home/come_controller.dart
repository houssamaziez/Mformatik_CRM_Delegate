import 'package:get/get.dart';

class HomeController extends GetxController {
  int indexBottomBar = 0;
  updateindexBottomBar(index) {
    indexBottomBar = index;
    update();
  }
}
