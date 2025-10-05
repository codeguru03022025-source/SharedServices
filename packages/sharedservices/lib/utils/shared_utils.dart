import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedUtils {
  static bool isTab = false;

  static Future<bool> checkConnectivity() async {
    final value = await Connectivity().checkConnectivity();
    if (value.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  static Future<void> share({
    required BuildContext context,
    required String text,
    String title = '',
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text.isEmpty ? null : text,
        title: title.isEmpty ? null : title,
        sharePositionOrigin: Rect.fromLTWH(
          0,
          0,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.3,
        ),
      ),
    );
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<void> makePhoneCall({required String contactno}) async {
    final Uri callUri = Uri(scheme: 'tel', path: contactno);

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Cannot launch phone call to $contactno");
      }
    } catch (e) {
      debugPrint("Error launching phone call: $e");
    }
  }
}
