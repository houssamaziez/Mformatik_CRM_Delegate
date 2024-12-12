import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../../../../../Controller/auth/auth_controller.dart';
import '../../../../../../Model/task_models/task.dart';
import '../../../../../../Util/Const/constants.dart';
import '../../../../../widgets/flutter_spinkit.dart';

CachedNetworkImage imageMessage(Item comment) {
  return CachedNetworkImage(
    imageUrl: Get.put(AuthController()).person!.img == null
        ? imageProfile
        : '${dotenv.get('urlHost')}/uploads/' +
            Get.put(AuthController()).person!.img.toString(),
    height: 20,
    width: 20,
    fit: BoxFit.cover,
    placeholder: (context, url) => spinkit,
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
