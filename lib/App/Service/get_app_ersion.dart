import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version; // Returns the app version (e.g., "1.0.0")
}
