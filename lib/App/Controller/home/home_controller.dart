import 'package:get/get.dart';

class HomeController extends GetxController {
  bool showContainers = true;
  upadteshowcontaner() {
    showContainers = !showContainers;
    update();
  }

  int indexBottomBar = 0;
  updateindexBottomBar(index) {
    indexBottomBar = index;
    update();
  }
}
