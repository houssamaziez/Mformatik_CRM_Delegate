import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Containers/container_blue.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            final user = authController.user!;
            final person = authController.person!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(180),
                        child: CachedNetworkImage(
                          imageUrl: person.img == null
                              ? 'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg'
                              : person.img!,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => spinkit,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
                  Text(person.firstName + " " + person.lastName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  containerwithblue(context,
                      widget: ListTile(
                        leading: Icon(
                          Icons.admin_panel_settings,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Role",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        subtitle: Text(
                          "Delegate",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  containerwithblue(context,
                      widget: ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Status",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        subtitle: Text(
                          user.isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            color: user.isActive ? Colors.green : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }
}
