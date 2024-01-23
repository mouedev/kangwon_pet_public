import 'dart:async';

import 'package:kangwon_pet/link_helper.dart';
import 'package:kangwon_pet/const.dart';
import 'package:kangwon_pet/mixin/snackbar_mixin.dart';
import 'package:kangwon_pet/model/launch_data.dart';
import 'package:kangwon_pet/widget/detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/content_detail_load_result.dart';
import '../model/detail_data_of_content.dart';
import '../model/result_list_item.dart';
import 'package:flutter/material.dart';

import '../provider.dart';
import '../repository.dart';

class ResultListItemWidget extends StatefulWidget {
  final ResultListItem _resultListItem;
  final Map<int, DetailDataOfContent> _detailOfItemsCache;
  final ListType _listType;
  final PartCode _partCode;
  final LocalCode _localCode;

  const ResultListItemWidget(this._resultListItem, this._detailOfItemsCache,
      this._listType, this._partCode, this._localCode,
      {super.key});

  @override
  State<ResultListItemWidget> createState() => _ResultListItemWidget();
}

class _ResultListItemWidget extends State<ResultListItemWidget>
    with snackBarMixin {
  late ContentDetailLoadResult _contentDetailLoadResult;
  DetailDataOfContent? _detailDataOfContent;
  String? imagePath;
  bool _moveToDetailScreen = false;
  DetainContentLoadState _detainContentLoadState =
      DetainContentLoadState.loading;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  Future<DetailDataOfContent?> _getDetailOfContent(ListType listType,
      PartCode partCode, LocalCode localCode, int contentNum) async {
    _contentDetailLoadResult = await loadDetailOfItemFromRepository(
        listType, partCode, localCode, contentNum);

    bool loadSucceeded = _contentDetailLoadResult.message.contains("success") &&
        !_contentDetailLoadResult.detailDataOfContent.isEmpty();
    if (loadSucceeded) {
      _detainContentLoadState = DetainContentLoadState.loaded;
      return _contentDetailLoadResult.detailDataOfContent;
    } else {
      _detainContentLoadState = DetainContentLoadState.failed;
      if (_moveToDetailScreen) {
        _moveToDetailScreen = false;
        showFailedToLoadContentDetail(widget._resultListItem.title);
      }
      subscribeConnectionStatus();
      return null;
    }
  }

  void _pushToCache(DetailDataOfContent? detailSequenceData) {
    if (detailSequenceData == null) {
      return;
    }

    widget._detailOfItemsCache
        .putIfAbsent(detailSequenceData.contentSeq, () => detailSequenceData);
  }

  void moveToDetailScreen(BuildContext context) {
    if (_detailDataOfContent == null) {
      return;
    }
    if (_detailDataOfContent!.isEmpty()) {
      return;
    }

    Provider.of<MainProvider>(context, listen: false).detailDataOfContent =
        _detailDataOfContent!;

    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen()),
      );
    });
  }

  void loadDetailContent() {
    int cacheMapKey = widget._resultListItem.contentSeq;
    bool isExistCache = widget._detailOfItemsCache.containsKey(cacheMapKey);
    if (isExistCache) {
      _detailDataOfContent = widget._detailOfItemsCache[cacheMapKey];
      bool? hasImage = _detailDataOfContent?.imageList.isNotEmpty;
      if (hasImage == true) {
        imagePath = widget._detailOfItemsCache[cacheMapKey]?.imageList.first;
      } else {
        imagePath = null;
      }
      _detainContentLoadState = DetainContentLoadState.loaded;
    } else {
      _getDetailOfContent(widget._listType, widget._partCode, widget._localCode,
              widget._resultListItem.contentSeq)
          .then((DetailDataOfContent? returnValue) {
        if (returnValue == null) {
          return;
        }

        _pushToCache(returnValue);
        _detailDataOfContent = returnValue;
        bool hasImage = returnValue.imageList.isNotEmpty;
        if (hasImage == true) {
          imagePath = returnValue.imageList.first;
          if (mounted) {
            setState(() {});
          }
        }

        if (_moveToDetailScreen) {
          moveToDetailScreen(context);
        }
      });
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool tryLoad = _detainContentLoadState == DetainContentLoadState.failed &&
        result != ConnectivityResult.none;
    if (tryLoad == true) {
      loadDetailContent();
    }
  }

  void subscribeConnectionStatus() {
    if (mounted == false) {
      return;
    }

    if (_connectivitySubscription != null) {
      return;
    }

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void initState() {
    super.initState();

    loadDetailContent();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (_detailDataOfContent != null) {
            moveToDetailScreen(context);
          } else if (_moveToDetailScreen == false) {
            _moveToDetailScreen = true;
            if (_detainContentLoadState == DetainContentLoadState.failed) {
              loadDetailContent();
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: makeColumnChildren(context)),
            )),
            SizedBox(
                height: 120,
                width: 120,
                child: (imagePath == null || imagePath!.isEmpty)
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image.network(imagePath!).image,
                                fit: BoxFit.cover),
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                      ))
          ],
        ));
  }

  List<Widget> makeColumnChildren(BuildContext context) {
    List<Widget> children = List.empty(growable: true);

    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return List.empty();
    }

    Widget area = makeTitleAndDescriptionRow(
        appLocalizations.areaName, widget._resultListItem.areaName);
    children.add(area);
    Widget part = makeTitleAndDescriptionRow(
        appLocalizations.partName, widget._resultListItem.partName);
    children.add(part);
    Widget title = makeTitleAndDescriptionRow(
        appLocalizations.title, widget._resultListItem.title);
    children.add(title);

    LaunchData telLaunchData = LaunchData(tel: widget._resultListItem.tel);
    Widget tel = makeTitleAndDescriptionRow(
        appLocalizations.tel, widget._resultListItem.tel,
        launchData: telLaunchData);
    children.add(tel);

    return children;
  }

  Widget makeTitleAndDescriptionRow(String title, String description,
      {LaunchData? launchData}) {
    Widget descriptionWidget = launchData == null
        ? Flexible(child: Text(description))
        : LinkHelper()
            .makeLaunchWidget(Theme.of(context).textTheme, launchData);
    EdgeInsetsGeometry margin = launchData == null
        ? const EdgeInsets.fromLTRB(0, 9, 0, 5)
        : const EdgeInsets.fromLTRB(0, 4, 0, 0);

    return Container(
        margin: margin,
        child: Row(
          children: [
            Container(
                alignment: const Alignment(-1.0, 0.0),
                width: 65,
                child: Text(title, textAlign: TextAlign.center)),
            descriptionWidget,
          ],
        ));
  }
}
