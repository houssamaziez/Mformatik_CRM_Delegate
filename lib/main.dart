import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:mformatic_crm_delegate/audio.dart';
import 'package:mformatic_crm_delegate/audioController.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart'; // For loading assets
import 'package:record/record.dart'; // Import record package
import 'package:path_provider/path_provider.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'App/View/splashScreen/splash_screen.dart';
import 'App/myapp.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  print(spalshscreenfirst.read('key'));
  runApp(const MyApp());
}

class Voice extends StatefulWidget {
  const Voice({Key? key}) : super(key: key);

  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  final AudioRecorder _record = AudioRecorder(); // Initialize the recorder
  bool _isRecording = false; // Track recording status
  String _audioPath = ''; // Path of the recorded audio file
  bool _isPlaying = false; // Track audio playing status
  final AudioPlayer _play = AudioPlayer();
  late Duration _audioDuration; // Track the duration of the recorded audio
  late Timer _timer; // Timer to show the recording duration
  FeedbackController feedbackController = Get.put(FeedbackController());
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // Check microphone permissions
  Future<void> _checkPermissions() async {
    bool hasPermission = await _record.hasPermission();
    if (!hasPermission) {
      print('Microphone permission denied');
    }
  }

  // Get the path to save the audio file
  Future<String> _getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_file.mp3'; // Save as .m4a file
  }

  // Start or stop recording
  void _toggleRecording() async {
    if (_isRecording) {
      final path = await _record.stop(); // Stop recording
      setState(() {
        _audioPath = path!;
        _isRecording = false;
      });
      _timer.cancel(); // Cancel the recording timer when stopped
    } else {
      final path = await _getAudioPath();
      // Create RecordConfig to pass to start method
      final config = RecordConfig(
        encoder: AudioEncoder.aacEld,
        bitRate: 128000,
        sampleRate: 44100,
      );
      await _record.start(config,
          path: path); // Start recording to the specified path
      setState(() {
        _audioPath = path;
        _isRecording = true;
      });
      _startRecordingTimer(); // Start recording timer
    }
  }

  // Start a timer to show the recording time
  void _startRecordingTimer() {
    _audioDuration = Duration(seconds: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _audioDuration = Duration(seconds: timer.tick);
      });
    });
  }

  // Play the recorded audio
  void _playAudio() async {
    if (_audioPath.isNotEmpty) {
      await _play.play(DeviceFileSource(_audioPath));
      setState(() {
        _isPlaying = true;
      });
      _play.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    }
  }

  // Cancel the recording and remove the file if needed
  void _cancelRecording() async {
    await _record.cancel(); // Cancel the current recording
    setState(() {
      _isRecording = false;
      _audioPath = '';
    });
    _timer.cancel(); // Cancel the timer if recording is canceled
  }

  @override
  void dispose() {
    super.dispose();
    _record.dispose(); // Clean up the recorder
    _timer.cancel(); // Cancel the recording timer if the widget is disposed
  }

  @override
  Widget build(BuildContext context) => Sizer(
        builder: (_, __, ___) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50.h),
                    _isRecording
                        ? Text(
                            'Recording: ${_audioDuration.inSeconds}s',
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.red),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: _toggleRecording,
                      child: Text(
                          _isRecording ? 'Stop Recording' : 'Start Recording'),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: _isRecording ? _cancelRecording : null,
                      child: const Text('Cancel Recording'),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed:
                          _isPlaying || _audioPath.isEmpty ? null : _playAudio,
                      child: Text(
                          _isPlaying ? 'Playing...' : 'Play Recorded Audio'),
                    ),
                    if (_audioPath.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          'Recorded Audio Path:\n$_audioPath',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    GetBuilder<FeedbackController>(
                        init: FeedbackController(),
                        builder: (controllerf) {
                          return VoiceMessageView(
                            controller: VoiceController(
                              audioSrc: controllerf.file!.path.toString(),
                              maxDuration: const Duration(seconds: 10),
                              isFile: true,
                              onComplete: () {
                                /// do something on complete
                              },
                              onPause: () {
                                /// do something on pause
                              },
                              onPlaying: () {
                                /// do something on playing
                              },
                              onError: (err) {
                                /// do somethin on error
                              },
                            ),
                            innerPadding: 12,
                            cornerRadius: 20,
                          );
                        }),
                    GetBuilder<FeedbackController>(
                        init: FeedbackController(),
                        builder: (controllerf) {
                          return ButtonAll(
                              isloading: controllerf.isLoadingadd,
                              function: () {
                                controllerf.addFeedbackVoice(
                                    clientId: 678133, voice: _audioPath);
                              },
                              title: 'add');
                        }),
                    GetBuilder<FeedbackController>(
                        init: FeedbackController(),
                        builder: (controllerf) {
                          return ButtonAll(
                              isloading: controllerf.isLoadingadd,
                              function: () {
                                controllerf.downloadFeedbackVoice("121");
                              },
                              title: 'add');
                        }),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
