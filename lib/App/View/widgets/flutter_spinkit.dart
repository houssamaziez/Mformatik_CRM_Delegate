import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

const spinkit = SpinKitSpinningLines(
  color: Color(0xff1073BA),
  size: 50.0,
);

const spinkit30 = SpinKitSpinningLines(
  color: Color(0xff1073BA),
  size: 30.0,
);
const spinkitwhite = SpinKitSpinningLines(
  color: Colors.white,
  size: 50.0,
);

var spinkwithtitle = SizedBox(
  width: 300,
  height: 300,
  child: Column(
    children: [
      Text("Loading data...".tr),
      SizedBox(
        height: 10,
      ),
      SpinKitSpinningLines(
        color: Color(0xff1073BA),
        size: 70.0,
      ),
    ],
  ),
);
