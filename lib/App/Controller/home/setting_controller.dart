import 'package:get/state_manager.dart';

import '../../Service/notification_handler.dart';
import '../../myapp.dart';

class SettingController  extends GetxController{

  bool index = false;

changeindex(  ){
     CriNotificationService.flutterBgInstance.isRunning().then((value) async {

      if (value) {
        index = false;
        update();
        CriNotificationService.flutterBgInstance.invoke('stopService');
         storage.write ('isNotification' ,index);
      }else{
 
   index = true;
        update();
          await Future.delayed(Duration(seconds: 2));
        await CriNotificationService.initializeService(isBackground: false);
         storage.write ('isNotification' ,index);


      }
     } );
  update();
}
@override
  void onInit() {
//  changeindex( );
   
//  changeindex(false);
    super.onInit();
  }

 }