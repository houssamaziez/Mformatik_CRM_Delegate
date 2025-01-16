import 'package:get/state_manager.dart';

import '../../Service/ws_notification/notification_handler.dart';
import '../../myapp.dart';

class SettingController  extends GetxController{

  bool index = false;

changeindex(  ){
     CriNotificationService.flutterBgInstance.isRunning().then((value) async {

      if (value) {
        index = false;
        update();
         storage.write ('isNotification' ,index);

        CriNotificationService.flutterBgInstance.invoke('stopService');
      }else{
 
   index = true;
        update();
         storage.write ('isNotification' ,index);

          await Future.delayed(Duration(seconds: 2));
        await CriNotificationService.initializeService(isBackground: false);


      }
     } );
  update();
}
@override
  void onInit() {
//  changeindex( );
   index = storage.read<bool> ('isNotification' ) ?? false;
   update();
//  changeindex(false);
    super.onInit();
  }

 }