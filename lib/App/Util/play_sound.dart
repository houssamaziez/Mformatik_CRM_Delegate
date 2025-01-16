import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../View/home/notifications/notifications_screen.dart';

Future<void> playSound() async {

  try {
    // Assuming the file is located in the assets folder
    await player.play(AssetSource('notification_track.wav'));

  } catch (e) {
    print('Error playing sound: $e');
  }
}
