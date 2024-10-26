// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smartschool/App/Util/Key/teatcherKey.dart';
// import 'package:smartschool/App/View/RoleView/TeacherView/Screens/Home/SupScrreens/Widget/button.dart';
// import 'package:smartschool/App/Controller/TeacherController/RoleController/roleController.dart';

// class Menu extends StatelessWidget {
//   const Menu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: SizedBox(
//         height: 33,
//         child: GetBuilder<RolesController>(
//           init: RolesController(),
//           builder: (controller) {
//             return controller.user.roles != null
//                 ? ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: controller.user.roles!.length,
//                     itemBuilder: (context, indexy) {
//                       return buttonMenuhome(
//                         context,
//                         title: controller.user.roles![indexy].schoolName
//                             .toString(),
//                         issekct: secretteatcherKey == indexy.toString()
//                             ? true
//                             : controller.user.roles![indexy].secretKey
//                                     .toString() ==
//                                 secretteatcherKey,
//                         onTap: () {
//                           print(secretteatcherKey);
//                           if (controller.user.roles![indexy].secretKey ==
//                               null) {
//                             secretteatcherKey = indexy.toString();
//                           } else {
//                             secretteatcherKey =
//                                 controller.user.roles![indexy].secretKey!;
//                           }

//                           controller.updateUserRole();
//                           controller.updateindextselct(
//                               controller.user.roles![indexy].roleID!, indexy);
//                         },
//                       );
//                     },
//                   )
//                 : Container();
//           },
//         ),
//       ),
//     );
//   }
// }
