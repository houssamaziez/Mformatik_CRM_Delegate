import 'package:flutter/material.dart';

Padding itemcircl(BuildContext context,
    {required String title,
    required String icon,
    required Function(BuildContext context) function,
    required int numnotification}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        InkWell(
          onTap: () {
            function(context);
          },
          borderRadius: BorderRadius.circular(180),
          child: Stack(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        180,
                      ),
                      color: const Color.fromARGB(255, 194, 194, 194)),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            180,
                          ),
                          color: Theme.of(context).cardColor),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/$icon",
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              numnotification == 0
                  ? const SizedBox()
                  : CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 9,
                      child: Center(
                        child: Text(
                          numnotification.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Color(0xff686868)),
        )
      ],
    ),
  );
}
