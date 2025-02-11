import 'package:flutter/material.dart';

import 'widgets/CustomTrackShape.dart';

class VoiceMessageViewPlay extends StatelessWidget {
  const VoiceMessageViewPlay(
      {Key? key,
      required this.controller,
      this.backgroundColor = Colors.white,
      this.activeSliderColor = Colors.red,
      this.notActiveSliderColor,
      this.circlesColor = Colors.red,
      this.innerPadding = 12,
      this.cornerRadius = 20,
      // this.playerWidth = 170,
      this.size = 38,
      this.refreshIcon = const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
      this.pauseIcon = const Icon(
        Icons.pause_rounded,
        color: Colors.white,
      ),
      this.playIcon = const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
      ),
      this.stopDownloadingIcon = const Icon(
        Icons.close,
        color: Colors.white,
      ),
      this.playPauseButtonDecoration,
      this.circlesTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      this.counterTextStyle = const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      this.playPauseButtonLoadingColor = Colors.white})
      : super(key: key);

  final controller;

  final Color backgroundColor;

  final Color circlesColor;

  final Color activeSliderColor;
  final Color? notActiveSliderColor;
  final TextStyle circlesTextStyle;
  final TextStyle counterTextStyle;
  final double innerPadding;
  final double cornerRadius;
  final double size;
  final Widget refreshIcon;
  final Widget pauseIcon;
  final Widget playIcon;
  final Widget stopDownloadingIcon;
  final Decoration? playPauseButtonDecoration;
  final Color playPauseButtonLoadingColor;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final color = circlesColor;
    final newTHeme = theme.copyWith(
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        minThumbSeparation: 0,
      ),
      splashColor: Colors.transparent,
    );
    return Container(
      padding: EdgeInsets.all(innerPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: ValueListenableBuilder(
        valueListenable: controller.updater,
        builder: (context, value, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _noises(newTHeme),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  const Spacer(
                    flex: 10,
                  ),
                  _changeSpeedButton(color),
                  const Spacer(),
                  Text(controller.remindingTime, style: counterTextStyle),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              const SizedBox(width: 10),
            ],
          );
        },
      ),
    );
  }

  SizedBox _noises(ThemeData newTHeme) => SizedBox(
        height: 30,
        width: controller.noiseWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: CurvedAnimation(
                parent: controller.animController,
                curve: Curves.ease,
              ),
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: controller.animController.value,
                  child: Container(
                    width: controller.noiseWidth,
                    // height: 6.w(),
                    color:
                        notActiveSliderColor ?? backgroundColor.withOpacity(.4),
                  ),
                );
              },
            ),
            Opacity(
              opacity: 0,
              child: Container(
                width: controller.noiseWidth,
                color: Colors.transparent.withOpacity(1),
                child: Theme(
                  data: newTHeme,
                  child: Slider(
                    value: controller.currentMillSeconds,
                    max: controller.maxMillSeconds,
                    onChangeStart: controller.onChangeSliderStart,
                    onChanged: controller.onChanging,
                    onChangeEnd: (value) {
                      controller.onSeek(
                        Duration(milliseconds: value.toInt()),
                      );
                      controller.play();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Transform _changeSpeedButton(Color color) => Transform.translate(
        offset: const Offset(0, -7),
        child: GestureDetector(
          onTap: () {
            controller.changeSpeed();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              controller.speed.playSpeedStr,
              style: circlesTextStyle,
            ),
          ),
        ),
      );
}
