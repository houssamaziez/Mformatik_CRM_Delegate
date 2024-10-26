// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
 

// class AddAnAccountScreen extends StatefulWidget {
//   const AddAnAccountScreen({super.key});

//   @override
//   State<AddAnAccountScreen> createState() => _AddAnAccountScreenState();
// }

// class _AddAnAccountScreenState extends State<AddAnAccountScreen> {
//   int index = 0;

//   TextEditingController schoolControolertext = TextEditingController();
//   TextEditingController etidientControolertext = TextEditingController();
//   TextEditingController condeinscpt = TextEditingController(text: "NU55261");
//   TextEditingController condeactivate = TextEditingController(text: "MT599");

//   final RolesController RoleController = Get.put(RolesController());

//   @override
//   Widget build(BuildContext context) {
//     List<Column> listwidget = [
//       Column(
//         children: [
//           MyTextfield(
//               namecontroller: condeinscpt,
//               title: "كود التسجيل",
//               suptitle: 'ادخل كود التسجيل',
//               ispassword: false),
//           MyTextfield(
//               namecontroller: condeactivate,
//               title: 'كود التفعيل',
//               suptitle: "ادخل كود التفعيل",
//               ispassword: false),
//           GetBuilder<AddTeacherRoleController>(
//               init: AddTeacherRoleController(),
//               builder: (addTeacherRoleController) {
//                 return ButtonAll(
//                     islogin: addTeacherRoleController.isLoading,
//                     function: () async {
//                       AddTeacherRoleRequest addTeacherRoleRequest =
//                           AddTeacherRoleRequest(
//                         teacherId: storageteatcher.read('ID').toString(),
//                         password: storageteatcher.read('Password').toString(),
//                         activeCode: condeactivate.text,
//                         regCode: condeinscpt.text,
//                         key: 'text',
//                         mobile: "966542161243",
//                         phoneId: "F2C7A6ED-F880-450C-9B75-3B3FD9261751-v3",
//                         phoneType: "iPhone",
//                       );

//                       await addTeacherRoleController.addTeacherRole(
//                           context, addTeacherRoleRequest);
//                     },
//                     title: 'اضافة');
//               })
//         ],
//       ),
//       Column(
//         children: [
//           MyTextfield(
//               namecontroller: schoolControolertext,
//               title: "كود المدرسة",
//               suptitle: "ادخل كود المدرسة",
//               ispassword: false),
//           MyTextfield(
//               namecontroller: etidientControolertext,
//               title: "كود المدرسة",
//               suptitle: "ادخل كود المدرسة",
//               ispassword: false),
//           GetBuilder<AddParentRoleController>(
//               init: AddParentRoleController(),
//               builder: (addTeacherRoleController) {
//                 return ButtonAll(
//                     islogin: addTeacherRoleController.isLoading,
//                     function: () {
//                       AddParentRoleRequest addParentRoleRequest =
//                           AddParentRoleRequest(
//                         id: RoleController.user.userID.toString(),
//                         password: storageteatcher.read('Password').toString(),
//                         code: schoolControolertext.text,
//                         stdNum: etidientControolertext.text,
//                         messageAR: '',
//                       );
//                       addTeacherRoleController.addParentRole(
//                           context, addParentRoleRequest);
//                     },
//                     title: 'اضافة');
//               })
//         ],
//       ),
//     ];

//     return Scaffold(
//       appBar: myappbar(context, title: 'اضافة حساب'),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Container(
//               height: 33,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(7),
//                   color: Theme.of(context).primaryColor),
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(1.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(7),
//                         color: Colors.white),
//                     child: Row(
//                       children: [
//                         buttonmenu(context, function: () {
//                           setState(() {
//                             index = 0;
//                           });
//                         }, title: 'حساب معلم', isselect: index == 0),
//                         buttonmenu(context, function: () {
//                           setState(() {
//                             index = 1;
//                           });
//                         }, title: 'حساب ولي أمر', isselect: index == 1),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             listwidget[index],
//           ],
//         ),
//       ),
//     );
//   }
// }
