import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/launch_data.dart';

class LinkHelper {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _openNaverMap(LaunchData launchData) async {
    if (launchData.hasMapData() == false) {
      debugPrint("Failed to open Naver map, has no map data");
      return;
    }

    bool succeedToRunNaverMapApp = await _openNaverMapApp(launchData);

    if (succeedToRunNaverMapApp == false) {
      _openNaverMapThroughExternalWeb(launchData);
    }
  }

  Future<bool> _openNaverMapApp(LaunchData launchData) async {
    try {
      String path =
          "nmap://place?lat=${launchData.latitude}&lng=${launchData.longitude}&name=${launchData.title}&zoom=10&appname=com.mouedev.kangwon_pet";

      return launchUrl(Uri.parse(path));
    } on Exception catch (_) {
      return false;
    }
  }

  void _openNaverMapThroughExternalWeb(LaunchData launchData) async {
    String path =
        "http://map.naver.com/index.nhn?enc=utf8&level=2&lng=${launchData.longitude}&lat=${launchData.latitude}&pinTitle=${launchData.title}&pinType=SITE&zoom=5";
    Uri url = Uri.parse(path);
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Widget makeLaunchWidget(TextTheme textTheme, LaunchData launchData) {
    String? textToShow = launchData.validTextToShow;

    if (textToShow == null) {
      debugPrint("Unable to make LaunchWidget, have none link to launch");
      return SizedBox.shrink();
    }

    bool isHomepageWebLink = launchData.homePage?.isNotEmpty ?? false;
    bool isCallLink = launchData.tel?.isNotEmpty ?? false;
    bool isMapLink = launchData.hasMapData();

    return Flexible(
        child: InkWell(
            onTap: () {
              if (isHomepageWebLink == true) {
                _launchInBrowser(Uri.parse(launchData.homePage!));
              } else if (isCallLink == true) {
                _makePhoneCall(launchData.tel!);
              } else if (isMapLink == true) {
                _openNaverMap(launchData);
              }
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(textToShow,
                        style: textTheme.titleMedium
                            ?.copyWith(color: Colors.blue))))));
  }
}
