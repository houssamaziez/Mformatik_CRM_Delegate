import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';

class RecordController extends GetxController {
  bool isRecording = false;
  bool animate = false;
  bool isPlaying = false;
  String audioPath = '';
  Duration audioDuration = Duration.zero;
  // final AudioRecorder _record = AudioRecorder();
  // final AudioPlayer _play = AudioPlayer();
  late Timer _timer;
  updateisRcord() {
    animate = !animate;
    update();
  }

  updateisRcordfa(bool value) {
    animate = value;
    update();
  }

  // Method to toggle recording
  void toggleRecording() async {
    if (isRecording == true) {
      // final path = await _record.stop();
      // if (path != null) {
      //   audioPath = path;
      // }
      isRecording = false;
      update();
      _timer.cancel();
      update();
    } else {
      audioPath = await _getAudioPath();
      // final config = RecordConfig(
      //   androidConfig: AndroidRecordConfig(),
      //   noiseSuppress: true,
      //   encoder: AudioEncoder.aacLc,
      //   bitRate: 128000,
      //   sampleRate: 44100,
      // );
      // await _record.start(config, path: audioPath);
      isRecording = true;
      _startRecordingTimer();
      update();
    }
  }

  // Method to start the recording timer
  void _startRecordingTimer() {
    audioDuration = const Duration(seconds: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      audioDuration = Duration(seconds: timer.tick);
      update();
    });
  }

  // Method to play the audio
  void playAudio() async {
    if (audioPath.isNotEmpty) {
      // await _play.play(DeviceFileSource(audioPath));
      isPlaying = true;
      update();
      // _play.onPlayerComplete.listen((_) {
      //   isPlaying = false;
      //   update();
      // });
    }
  }

  // Method to cancel the recording
  void cancelRecording() async {
    // await _record.cancel();
    isRecording = false;
    audioPath = '';
    _timer.cancel();
    update();
  }

  // Method to delete the recorded audio
  void deleteRecording() async {
    if (audioPath.isNotEmpty) {
      final file = File(audioPath);
      if (await file.exists()) {
        await file.delete();
        audioPath = '';
        audioDuration = Duration.zero;
        isPlaying = false;
        update();
      }
    }
  }

  Future<String> _getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    print("--------------------------------");
    print(directory.path);

    return '${directory.path}/audio_file.mpga';
  }
}
