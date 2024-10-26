// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smartschool/App/Util/Extension/extension_padding.dart';
// import 'package:smartschool/App/Util/Style/container/stylecontainer.dart';

// import '../../../../Controller/TeacherController/Home/AttendanceController/timetableController.dart';
// import '../../../RoleView/TeacherView/Screens/Home/SupScrreens/Widget/tableday.dart';

// class ActiveStatus extends StatelessWidget {
//   const ActiveStatus({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         tibleday(context),
//         Align(
//           alignment: Alignment.bottomRight,
//           child: const Text(
//             "الاشراف و المناوبة في اليوم الحالي",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//           ).paddingOnly(right: 10, top: 8),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         GetBuilder<TimetableController>(
//           init: TimetableController(),
//           builder: (controller) {
//             return ListView.builder(
//               shrinkWrap: true,
//               padding: EdgeInsets.zero,
//               itemCount: controller.eshrafEntries.length,
//               itemBuilder: (context, index) {
//                 return TextIchraf(
//                   context: context,
//                   title: controller.eshrafEntries[index].description,
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class TextIchraf extends StatelessWidget {
//   final BuildContext context;
//   final String title;

//   const TextIchraf({super.key, required this.context, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
//       child: Container(
//         decoration: StyleContainer.style1,
//         height: 48,
//         width: double.infinity,
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: CircleAvatar(
//                 radius: 5,
//                 backgroundColor: Theme.of(context).primaryColor,
//               ),
//             ),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
