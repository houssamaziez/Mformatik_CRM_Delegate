import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Model/reason_mission.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';

import '../../Controller/widgetsController/expandable_controller.dart';

// class ExpandableItemSelector extends StatelessWidget {
//   final List<String> items;
//   final String title;
//   final String initialItem;

//   ExpandableItemSelector({
//     Key? key,
//     required this.items,
//     required this.title,
//     this.initialItem = '',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ExpandableController expandableController =
//         Get.put(ExpandableController());

//     if (initialItem.isNotEmpty) {
//       expandableController.selectedItem.value = initialItem;
//     }

//     return Container(
//       decoration: StyleContainer.style1,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               title,
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.blueGrey[800]),
//             ),
//           ),
//           Obx(() {
//             return ExpansionTile(
//               key: Key(expandableController.selectedItem.value),
//               title: Text(
//                 expandableController.selectedItem.value.isEmpty
//                     ? 'Select item'
//                     : expandableController.selectedItem.value,
//                 style: TextStyle(fontSize: 16, color: Colors.black87),
//               ),
//               trailing: Icon(
//                 expandableController.isExpanded.value
//                     ? Icons.arrow_drop_up
//                     : Icons.arrow_drop_down,
//                 color: Colors.blueGrey,
//               ),
//               initiallyExpanded: expandableController.isExpanded.value,
//               onExpansionChanged: (expanded) {
//                 expandableController.toggleExpanded();
//               },
//               children: items.map((item) {
//                 return GestureDetector(
//                   onTap: () {
//                     expandableController.selectItem(item);
//                   },
//                   child: Container(
//                     color: Colors.transparent, // اللون الشفاف للتفاعل
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12.0, horizontal: 16.0),
//                       child: Text(
//                         item,
//                         style: TextStyle(fontSize: 15, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

class SelectReasdon extends StatelessWidget {
  final List<ReasonMission> items;
  final String title;

  SelectReasdon({
    Key? key,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpandableControllerd expandableController =
        Get.put(ExpandableControllerd());

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Obx(() {
            return ExpansionTile(
              key: Key(expandableController.selectedItem.value?.label ?? ''),
              title: Text(
                expandableController.selectedItem.value == null
                    ? 'Select Reasons'
                    : expandableController.selectedItem.value!.label!,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              trailing: Icon(
                expandableController.isExpanded.value
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
              initiallyExpanded: expandableController.isExpanded.value,
              onExpansionChanged: (expanded) {
                expandableController.toggleExpanded();
              },
              children: items.map((item) {
                return GestureDetector(
                  onTap: () {
                    expandableController.selectItem(item);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        item.label!,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          // Show a TextField if "autre" is selected
          Obx(() {
            if (expandableController.selectedItem.value?.label == 'autre') {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller:
                      expandableController.controllerTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Please specify',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }
            return SizedBox.shrink(); // Returns an empty widget if not needed
          }),
        ],
      ),
    );
  }
}
