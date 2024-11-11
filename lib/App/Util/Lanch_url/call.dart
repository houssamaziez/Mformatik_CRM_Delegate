import 'package:url_launcher/url_launcher_string.dart';

void makePhoneCall({String path = '23456789'}) async {
  final String phoneUrl = "tel:+213$path";

  if (await canLaunchUrlString(phoneUrl)) {
    await launchUrlString(phoneUrl, mode: LaunchMode.externalApplication);
  } else {
    print('Could not launch $phoneUrl');
    throw 'Could not launch $phoneUrl';
  }
}
