import 'package:url_launcher/url_launcher.dart';

void _sendEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'example@example.com',
    queryParameters: {
      'subject': 'Hello',
      'body': 'Hi there!',
    },
  );
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $emailUri';
  }
}
