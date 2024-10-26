import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImageWidget extends StatelessWidget {
  final String assetName; // Path to the SVG asset

  SvgImageWidget({required this.assetName});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      fit: BoxFit.fill,
      assetName, height: double.infinity,
      width: double.maxFinite,
      semanticsLabel: 'SVG Image', // Accessibility label
      placeholderBuilder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20.0),
        child: const CircularProgressIndicator(), // Placeholder while loading
      ),
    );
  }
}
