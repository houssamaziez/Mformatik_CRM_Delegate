import 'package:flutter/material.dart';
import '../../../../Util/Style/stylecontainer.dart';
import '../../../widgets/app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> listtaccounts = [
    "الإشعار 1", // Sample items in Arabic
    "الإشعار 2",
    "الإشعار 3",
    "الإشعار 4",
    "الإشعار 5",
    "الإشعار 6",
  ];

  bool notifictaionmessag = true,
      notificatioNote = true,
      notificationmokhalfa = true,
      notificationalart = true,
      update = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to RTL
      child: Scaffold(
        appBar:
            myappbar(context, title: "الإشعارات"), // Set the title in Arabic
        body: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align children to the end (right)
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "الإشعارات", // Header in Arabic
                textAlign: TextAlign.right, // Align text to the right
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: StyleContainer.style1,
                child: Column(
                  children: [
                    itemNotification(
                      title: listtaccounts[0],
                      function: () {
                        setState(() {
                          notifictaionmessag = !notifictaionmessag;
                        });
                      },
                      isselct: notifictaionmessag,
                    ),
                    itemNotification(
                      title: listtaccounts[1],
                      function: () {
                        setState(() {
                          notificatioNote = !notificatioNote;
                        });
                      },
                      isselct: notificatioNote,
                    ),
                    itemNotification(
                      title: listtaccounts[2],
                      function: () {
                        setState(() {
                          notificationmokhalfa = !notificationmokhalfa;
                        });
                      },
                      isselct: notificationmokhalfa,
                    ),
                    itemNotification(
                      title: listtaccounts[3],
                      function: () {
                        setState(() {
                          notificationalart = !notificationalart;
                        });
                      },
                      isselct: notificationalart,
                    ),
                    itemNotification(
                      title: listtaccounts[4],
                      function: () {
                        setState(() {
                          update = !update;
                        });
                      },
                      isselct: update,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding itemNotification({
    required String title,
    required Function function,
    required bool isselct,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          function();
        },
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.right, // Align text to the right
          ),
          trailing: Image.asset(
            isselct
                ? "assets/icons/Rectangleact.png"
                : "assets/icons/Rectangledes.png",
            height: 20,
            width: 42,
          ),
        ),
      ),
    );
  }
}
