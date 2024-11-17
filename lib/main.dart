import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'App/Controller/RecordController.dart';
import 'App/View/splashScreen/splash_screen.dart';
import 'App/myapp.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  print(spalshscreenfirst.read('key'));
  runApp(const MyApp());
}

class Voice extends StatefulWidget {
  Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  final RecordController recordController = Get.put(RecordController());

  bool _animate = false;
  bool showContainers = false; // Controls the visibility of the bottom sheet

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GetBuilder<RecordController>(builder: (controller) {
          final controlledVoiceMessageViewMy = VoiceController(
            audioSrc: controller.audioPath,
            maxDuration: Duration(seconds: controller.audioDuration.inSeconds),
            isFile: true,
            onComplete: () {
              // Do something on complete
            },
            onPause: () {
              // Do something on pause
            },
            onPlaying: () {
              // Do something on playing
            },
            onError: (err) {
              // Handle error
            },
          );

          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    showContainers = !showContainers; // Toggle animation
                  });
                },
                child: Text('Play Animation Sheet'),
              ),
            ),
          );
        }),
      ),
    );
  }
}
