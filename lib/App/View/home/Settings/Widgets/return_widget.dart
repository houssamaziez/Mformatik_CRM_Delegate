// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smartschool/App/Util/Extension/extension_widgets.dart';
// import 'package:smartschool/App/Util/Style/container/stylecontainer.dart';
// import 'package:smartschool/App/Util/Style/style_text.dart';
// import 'package:smartschool/App/View/RoleView/TeacherView/Screens/Home/SupScrreens/Widget/Screenhomewait/screenwaitActivet.dart';
// import 'package:smartschool/App/View/RoleView/TeacherView/Screens/Home/SupScrreens/Widget/Screenhomewait/dayisnull.dart';
// import 'package:smartschool/App/View/RoleView/TeacherView/Screens/Home/SupScrreens/Widget/itemcircl.dart';

// import '../../../../Controller/TeacherController/RoleController/roleController.dart';
// import '../../../../Controller/TeacherController/TeacherInfoController.dart';
// import '../../../../Util/Go.dart';
// import '../../flutter_spinkit.dart';
// import '../../../RoleView/TeacherView/Screens/Home/Home.dart';
// import '../../../RoleView/TeacherView/Screens/Home/SupScrreens/HomeScreen/SupScreen Home/Course/courseGridScreen.dart';
// import '../screenSetting.dart';
// import 'active_status.dart';
// import 'menu.dart';

// Column returnWidget(BuildContext context, int state) {
//   Widget content;
//   switch (state) {
//     case 105:
//       content = Column(
//         children: [
//           const Menu(),
//           GetBuilder<TeacherControllerNewHome>(
//             init: TeacherControllerNewHome(),
//             builder: (controller) {
//               return Column(
//                 children: [
//                   controller.responseInfo.day == null
//                       ? isdaynull(context)
//                       : Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 itemcircl(
//                                   context,
//                                   icon: 'Single, User, Info.png',
//                                   numnotification: 0,
//                                   title: 'تنبيهات الحضور',
//                                   function: (context) {
//                                     Go.to(
//                                         context,
//                                         const CourseGridScreen(
//                                             role: 'تنبيهات الحضور'));
//                                   },
//                                 ),
//                                 itemcircl(
//                                   context,
//                                   icon: 'messag.png',
//                                   numnotification: 0,
//                                   title: 'الملاحظات',
//                                   function: (context) {
//                                     Go.to(
//                                         context,
//                                         const CourseGridScreen(
//                                             role: 'الملاحظات'));
//                                   },
//                                 ),
//                                 itemcircl(
//                                   context,
//                                   icon: 'Block, Delete, Stop.png',
//                                   numnotification: 0,
//                                   title: 'المخالفات السلوكية',
//                                   function: (context) {
//                                     Go.to(
//                                         context,
//                                         const CourseGridScreen(
//                                             role: 'المخالفات السلوكية'));
//                                   },
//                                 ),
//                                 itemcircl(
//                                   context,
//                                   icon: 'Group222.png',
//                                   numnotification: 0,
//                                   title: 'احصائيات الحضور',
//                                   function: (context) {
//                                     Go.to(
//                                         context,
//                                         const CourseGridScreen(
//                                           role: 'احصائيات الحضور',
//                                         ));
//                                   },
//                                 ),
//                               ],
//                             ),
//                             const ActiveStatus(),
//                           ],
//                         ),
//                 ],
//               );
//             },
//           ),
//         ],
//       );
//       break;

//     case 104:
//       content = Column(
//         children: [
//           const Menu(),
//           Column(
//             children: [
//               waitActivate(
//                 context,
//                 image: 'standby1.png',
//                 title: 'في انتظار التفعيل',
//               ),
//               InkWell(
//                 onTap: () {
//                   cleanAllControllers();

//                   Go.replace(
//                     context,
//                     HomeTeacher(),
//                   );
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 40,
//                   // ignore: sort_child_properties_last
//                   child:
//                       'تحديث'.style(color: Colors.white, fontSize: 16).center(),
//                   decoration: StyleContainer.stylecontainer(
//                       color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//       break;

//     case 106:
//       content = Column(
//         children: [
//           waitActivate(
//             context,
//             image: 'block-user 1.png',
//             title: "الحساب محظور",
//             isaddbotton: false,
//           ),
//         ],
//       );
//       break;
//     case 103:
//       content = Column(
//         children: [
//           const Menu(),
//           waitActivate(
//             context,
//             image: 'block-user 1.png',
//             title: "الحساب محظور",
//             isaddbotton: false,
//           ),
//         ],
//       );
//       break;

//     case 404:
//       content = Column(
//         children: [
//           const Menu(),
//           waitActivate(
//             context,
//             image: 'Group 298.png',
//             title: "لا يوجد حسابات مضافة",
//             isaddbotton: true,
//           ),
//         ],
//       );
//       break;

//     default:
//       content = Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height / 2,
//           ),
//           const Center(
//             child: spinkit,
//           ),
//         ],
//       );
//       break;
//   }

//   return Column(
//     children: [
//       content,
//     ],
//   );
// }
