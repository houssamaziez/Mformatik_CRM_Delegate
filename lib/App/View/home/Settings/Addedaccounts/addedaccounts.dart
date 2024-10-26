// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smartschool/App/Controller/TeacherController/RoleController/roleController.dart';
// import 'package:smartschool/App/Util/Extension/refresh.dart';
// import 'package:smartschool/App/Util/Go.dart';
// import 'package:smartschool/App/View/Widgets/appbar.dart';
// import 'package:smartschool/App/View/Widgets/flutter_spinkit.dart';

// import '../../../../Util/Style/container/stylecontainer.dart';
// import '../../Dialog/delete.dart';
// import 'addAnAccount.dart';

// class AddedAccounts extends StatelessWidget {
//   AddedAccounts({super.key});
//   final RolesController controller = Get.put(RolesController());
//   Future<void> _refreshScreen(context) async {
//     controller.fetchUserRole();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myappbar(context, title: "الحسابات المضافة"),
//       body: ListView(
//         children: [
//           GetBuilder<RolesController>(
//               init: RolesController(),
//               builder: (controller) {
//                 return controller.statrole != null
//                     ? controller.isLoading == true
//                         ? SizedBox(
//                             height: 300, child: Center(child: spinkwithtitle))
//                         : Column(
//                             children: [
//                               ListView.builder(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: controller.user.roles!.length,
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Container(
//                                         decoration: StyleContainer.style1,
//                                         child: ListTile(
//                                           leading: Image.asset(
//                                             "assets/icons/school_82202891.png",
//                                             height: 24,
//                                             width: 24,
//                                           ),
//                                           trailing: InkWell(
//                                             onTap: () {
//                                               showDeleteuser(
//                                                 context,
//                                                 (code) {
//                                                   controller.deleteTeacherRole(
//                                                       context, code);
//                                                 },
//                                                 codeController: controller
//                                                     .user.roles![index].code!,
//                                               );
//                                             },
//                                             child: Image.asset(
//                                               "assets/icons/user-profile.7.png",
//                                               height: 24,
//                                               width: 24,
//                                             ),
//                                           ),
//                                           title: Text(controller
//                                               .user.roles![index].schoolName
//                                               .toString()),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Center(
//                                 child: InkWell(
//                                   onTap: () {
//                                     Go.to(context, const AddAnAccountScreen());
//                                   },
//                                   child: Container(
//                                     width: 153,
//                                     height: 40,
//                                     decoration: const BoxDecoration(
//                                         color: Color(0xff1073BA),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(12))),
//                                     child: const Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "اضافة حساب",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Icon(
//                                             Icons.add_circle_outline_rounded,
//                                             color: Colors.white,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                     : Container();
//               }),
//         ],
//       ).addRefreshIndicator(
//         onRefresh: () => _refreshScreen(context),
//       ),
//     );
//   }
// }
