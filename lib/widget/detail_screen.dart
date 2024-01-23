import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kangwon_pet/link_helper.dart';
import 'package:kangwon_pet/model/launch_data.dart';
import 'package:kangwon_pet/provider.dart';
import 'package:kangwon_pet/mixin/util_mixin.dart';
import 'package:kangwon_pet/widget/image_screen.dart';
import 'package:kangwon_pet/widget/google_map_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/detail_data_of_content.dart';

class DetailScreen extends StatelessWidget with utilMixin {
  DetailScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  Widget makeTitleAndDescriptionRow(
      TextTheme textTheme, String title, String description,
      {LaunchData? launchData}) {
    Widget descriptionWidget = launchData == null
        ? Flexible(
            child: Text(
            description,
            style: textTheme.titleSmall,
            textAlign: TextAlign.left,
          ))
        : LinkHelper().makeLaunchWidget(textTheme, launchData);

    EdgeInsetsGeometry margin = launchData == null
        ? const EdgeInsets.fromLTRB(10, 7, 10, 7)
        : const EdgeInsets.fromLTRB(10, 0, 10, 0);

    return Container(
        margin: margin,
        child: Row(
          children: [
            Container(
                alignment: const Alignment(-1.0, 0.0),
                width: 80,
                child: Text(title,
                    textAlign: TextAlign.center, style: textTheme.titleMedium)),
            const SizedBox(
              width: 5,
            ),
            descriptionWidget,
          ],
        ));
  }

  void addToColumnChildListIfImageExist(BuildContext context,
      List<Widget> columnChildList, List<String> imageList) {
    columnChildList.add(const SizedBox(
      height: 7,
    ));

    if (imageList.isEmpty == true) {
      return;
    }
    String imagePath = imageList.first;
    if (imagePath.isEmpty == true) {
      return;
    }

    double imageSize = math.min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) *
        2 /
        3;

    Widget imageWidget = InkWell(
        onTap: () {
          Future.delayed(Duration.zero, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImageScreen()),
            );
          });
        },
        child: Semantics(
            label: "확대하려면 이미지를 선택하세요.",
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.network(imagePath).image, fit: BoxFit.cover),
                  border: Border.all(color: Colors.lightGreen, width: 1),
                  borderRadius: BorderRadius.circular(10)),
            )));

    columnChildList.add(imageWidget);
    columnChildList.add(const Divider(color: Colors.black26));
  }

  void addToColumnChildListIfValueIsNotEmpty(TextTheme textTheme,
      List<Widget> columnChildList, String title, String description,
      {bool addDivider = true, LaunchData? launchData}) {
    if (description.isEmpty == true) {
      return;
    }

    Widget widget = makeTitleAndDescriptionRow(textTheme, title, description,
        launchData: launchData);
    columnChildList.add(widget);

    if (addDivider == true) {
      columnChildList.add(const Divider(color: Colors.black26));
    }
  }

  List<Widget> makeColumnChildren(BuildContext context, TextTheme textTheme,
      DetailDataOfContent detailDataOfContent) {
    List<Widget> children = List.empty(growable: true);
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return List.empty();
    }

    addToColumnChildListIfImageExist(
        context, children, detailDataOfContent.imageList);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.areaName, detailDataOfContent.areaName);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.partName, detailDataOfContent.partName);

    addToColumnChildListIfValueIsNotEmpty(
        textTheme, children, appLocalizations.title, detailDataOfContent.title);

    LaunchData telLaunchData = LaunchData(tel: detailDataOfContent.tel);
    addToColumnChildListIfValueIsNotEmpty(
        textTheme, children, appLocalizations.tel, detailDataOfContent.tel,
        launchData: telLaunchData);

    LaunchData mapLaunchData = LaunchData(
        title: detailDataOfContent.title,
        address: detailDataOfContent.address,
        latitude: detailDataOfContent.latitude,
        longitude: detailDataOfContent.longitude);
    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.address, detailDataOfContent.address,
        launchData: mapLaunchData);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.usedTime, detailDataOfContent.usedTime);

    LaunchData homePageLaunchData = LaunchData(homePage: detailDataOfContent.homePage);
    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.homePage, detailDataOfContent.homePage,
        launchData: homePageLaunchData);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.content, detailDataOfContent.content);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.provisionSupply, detailDataOfContent.provisionSupply);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.petFacility, detailDataOfContent.petFacility);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.restaurant, detailDataOfContent.restaurant);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.parkingLot, detailDataOfContent.parkingLot);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.mainFacility, detailDataOfContent.mainFacility);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.usedCost, detailDataOfContent.usedCost);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.policyCautions, detailDataOfContent.policyCautions);

    addToColumnChildListIfValueIsNotEmpty(
        textTheme,
        children,
        appLocalizations.emergencyResponse,
        detailDataOfContent.emergencyResponse);

    addToColumnChildListIfValueIsNotEmpty(
        textTheme, children, appLocalizations.memo, detailDataOfContent.memo);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.bathFlag, detailDataOfContent.bathFlag);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.provisionFlag, detailDataOfContent.provisionFlag);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.petFlag, detailDataOfContent.petFlag);

    addToColumnChildListIfValueIsNotEmpty(textTheme, children,
        appLocalizations.petWeight, detailDataOfContent.petWeight);

    addToColumnChildListIfGPSLocationExist(
        context,
        children,
        detailDataOfContent.title,
        detailDataOfContent.latitude,
        detailDataOfContent.longitude);

    return children;
  }

  void addToColumnChildListIfGPSLocationExist(
      BuildContext context,
      List<Widget> columnChildList,
      String title,
      String latitude,
      String longitude) {
    if (latitude.isEmpty || longitude.isEmpty) {
      return;
    }

    final mediaQuery = MediaQuery.of(context);
    double minSize = math.min(mediaQuery.size.width, mediaQuery.size.height);

    columnChildList.add(SizedBox(
        width: minSize,
        height: minSize,
        child: GoogleMapWidget(
            title, double.parse(latitude), double.parse(longitude))));
  }

  @override
  Widget build(BuildContext context) {
    DetailDataOfContent? detailDataOfContent = context.select(
        (MainProvider mainProvider) => mainProvider.detailSequencePartData);

    if (detailDataOfContent == null) {
      return const Center(child: Text("정보가 없습니다."));
    }

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              jumpScrollPositionToTop(_scrollController);
            },
            child: Text(detailDataOfContent.title)),
        flexibleSpace: GestureDetector(
          onTap: () {
            jumpScrollPositionToTop(_scrollController);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: makeColumnChildren(context, textTheme, detailDataOfContent),
        ),
        controller: _scrollController,
      ),
    );
  }
}
