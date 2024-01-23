import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kangwon_pet/provider.dart';
import 'package:kangwon_pet/repository.dart';
import 'package:kangwon_pet/mixin/snackbar_mixin.dart';
import 'package:kangwon_pet/mixin/util_mixin.dart';
import 'package:kangwon_pet/widget/result_list_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../const.dart';
import '../model/detail_data_of_content.dart';
import '../model/content_list_load_result.dart';
import '../model/result_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with snackBarMixin, utilMixin {
  bool isAppInitializedFailed = true;
  ContentListLoadResult? contentList;
  final Map<int, DetailDataOfContent> _detailOfItemsCache = {};

  final ScrollController _scrollController = ScrollController();
  ListLoadState _listLoadState = ListLoadState.none;
  bool isShowingLoadingProgress = false;
  final List<DropdownMenuItem<ListType>> _listTypeDropdownMenuItems =
      List.empty(growable: true);
  final List<DropdownMenuItem<LocalCode>> _localCodeDropdownMenuItems =
      List.empty(growable: true);
  final List<DropdownMenuItem<PartCode>> _partCodeDropdownMenuItems =
      List.empty(growable: true);

  void _getFirstContentList(BuildContext context, MainProvider mainProvider,
      {bool clear = false, bool removeSplashScreen = false}) {
    if (clear) {
      mainProvider.pageNum = 0;
      mainProvider.clearList(notify: true);
    }
    _loadList(context, mainProvider, 0, removeSplashScreen: removeSplashScreen);
  }

  void _initScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        bool loadListMore = _listLoadState == ListLoadState.loaded ||
            _listLoadState == ListLoadState.failed;
        if (loadListMore) {
          MainProvider mainProvider =
              Provider.of<MainProvider>(context, listen: false);

          _listLoadState = ListLoadState.requestedToLoadMore;
          int pageToLoad = mainProvider.pageNum + 1;
          _loadList(context, mainProvider, pageToLoad);
        } else if (_listLoadState == ListLoadState.reachedToMaxCount) {
          showLastListItemSnackBar();
        }
      }
    });
  }

  void initDropDownList(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return;
    }

    _listTypeDropdownMenuItems.clear();
    _localCodeDropdownMenuItems.clear();
    _partCodeDropdownMenuItems.clear();

    for (var listType in ListType.values.toList()) {
      String displayName = appLocalizations.listType(listType.name);
      _listTypeDropdownMenuItems
          .add(DropdownMenuItem(value: listType, child: Text(displayName)));
    }

    for (var localCode in LocalCode.values.toList()) {
      String displayName = appLocalizations.localCode(localCode.name);
      _localCodeDropdownMenuItems
          .add(DropdownMenuItem(value: localCode, child: Text(displayName)));
    }

    for (var partCode in PartCode.values.toList()) {
      String displayName = appLocalizations.partCode(partCode.name);
      _partCodeDropdownMenuItems
          .add(DropdownMenuItem(value: partCode, child: Text(displayName)));
    }
  }

  void _loadList(BuildContext context, MainProvider mainProvider, int pageNum,
      {bool removeSplashScreen = false}) async {
    if (removeSplashScreen == false) {
      showLoadingDialog(context);
    }

    _listLoadState = ListLoadState.loading;
    ListType listType = mainProvider.listType;
    ContentListLoadResult list;

    if (listType == ListType.part) {
      list = await loadListFromRepository(listType, pageNum,
          partCode: mainProvider.partCode);
    } else {
      list = await loadListFromRepository(listType, pageNum,
          localCode: mainProvider.localCode);
    }

    bool loadSucceeded =
        list.message.contains("success") && list.resultList.isNotEmpty;
    if (loadSucceeded) {
      isAppInitializedFailed = false;
      mainProvider.pageNum = pageNum;
      mainProvider.listTotalCount = list.totalCount;
      mainProvider.addList(list.resultList);

      if (list.totalCount == mainProvider.list.length) {
        _listLoadState = ListLoadState.reachedToMaxCount;
      } else {
        _listLoadState = ListLoadState.loaded;
      }
    } else {
      _listLoadState = ListLoadState.failed;
      showFailedToLoadContentList();
    }

    if (removeSplashScreen) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FlutterNativeSplash.remove();
      });
    }

    if (isShowingLoadingProgress == false) {
      return;
    }

    Future.delayed(Duration.zero, () {
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
      isShowingLoadingProgress = false;
    });
  }

  showLoadingDialog(BuildContext context) {
    if (isShowingLoadingProgress) {
      return;
    }

    isShowingLoadingProgress = true;
    String loading = AppLocalizations.of(context)?.loading ?? "loading...";
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7), child: Text(loading)),
        ],
      ),
    );

    Future.delayed(Duration.zero, () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    });
  }

  void setAppBarTitle(MainProvider mainProvider, ListType listType) {
    ListType listType = mainProvider.listType;
    String title;
    if (listType == ListType.part) {
      title = mainProvider.partCode.displayName;
    } else {
      title = mainProvider.localCode.displayName;
    }
    mainProvider.mainScreenTitle = title;
  }

  Widget _localSelectDropdownButtonWidget(
      BuildContext context, MainProvider mainProvider) {
    LocalCode localCode = mainProvider.localCode;
    return Semantics(
        label: "선택하여 지역을 선택하세요.",
        child: DropdownButton(
          items: _localCodeDropdownMenuItems,
          focusColor: Colors.transparent,
          onChanged: (LocalCode? value) {
            if (value == null) {
              return;
            }
            if (localCode == value) {
              return;
            }

            mainProvider.localCode = value;
            setAppBarTitle(mainProvider, ListType.local);
            _getFirstContentList(context, mainProvider, clear: true);
          },
          value: localCode,
        ));
  }

  Widget _partSelectDropdownButtonWidget(
      BuildContext context, MainProvider mainProvider) {
    PartCode partCode = mainProvider.partCode;
    return Semantics(
        label: "선택하여 종류를 선택하세요.",
        child: DropdownButton(
          items: _partCodeDropdownMenuItems,
          focusColor: Colors.transparent,
          onChanged: (PartCode? value) {
            if (value == null) {
              return;
            }
            if (partCode == value) {
              return;
            }

            mainProvider.partCode = value;
            setAppBarTitle(mainProvider, ListType.part);
            _getFirstContentList(context, mainProvider, clear: true);
          },
          value: partCode,
        ));
  }

  Widget conditionSelectWidget(
      BuildContext context, MainProvider mainProvider) {
    ListType listType = mainProvider.listType;

    Widget secondDropDownButton = listType == ListType.part
        ? _partSelectDropdownButtonWidget(context, mainProvider)
        : _localSelectDropdownButtonWidget(context, mainProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 10, 5),
      child: Row(children: [
        Semantics(
            label: "선택하여 종류를 선택하세요.",
            child: DropdownButton(
              items: _listTypeDropdownMenuItems,
              value: listType,
              focusColor: Colors.transparent,
              onChanged: (ListType? value) {
                if (value == null) {
                  return;
                }
                if (value == listType) {
                  return;
                }
                mainProvider.listType = value;
                setAppBarTitle(mainProvider, listType);
                _getFirstContentList(context, mainProvider, clear: true);
              },
            )),
        const SizedBox(
          width: 14,
        ),
        secondDropDownButton,
      ]),
    );
  }

  ListView listView(BuildContext context, MainProvider mainProvider,
          List<ResultListItem> list) =>
      ListView.separated(
        controller: _scrollController,
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, int idx) {
          ResultListItem resultListItem = list[idx];

          ListType listType = mainProvider.listType;
          PartCode partCode = mainProvider.partCode;
          LocalCode localCode = mainProvider.localCode;

          ResultListItemWidget resultListItemWidget = ResultListItemWidget(
              resultListItem,
              _detailOfItemsCache,
              listType,
              partCode,
              localCode);

          return ListTile(title: resultListItemWidget);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(thickness: 1);
        },
      );

  void exitApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  Widget initFailedWidget(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return const SizedBox.shrink();
    }

    String retry = appLocalizations.retry;
    String exit = appLocalizations.exit;

    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  MainProvider mainProvider =
                      Provider.of<MainProvider>(context, listen: false);
                  _getFirstContentList(context, mainProvider);
                },
                child: Text(retry)),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  exitApp();
                },
                child: Text(exit))
          ],
        ));
  }

  Drawer drawer() {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/dogmountain.png'),
            ),
            accountName: Text('mouedev'),
            accountEmail: Text('mouedev@gmail.com'),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            iconColor: Colors.purple,
            focusColor: Colors.purple,
            title: const Text('License'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LicensePage()));
            },
            trailing: const Icon(Icons.navigate_next),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      MainProvider mainProvider =
          Provider.of<MainProvider>(context, listen: false);
      _getFirstContentList(context, mainProvider, removeSplashScreen: true);
      setAppBarTitle(mainProvider, mainProvider.listType);
    });

    _initScrollController(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initDropDownList(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: true);

    List<ResultListItem> list =
        context.select((MainProvider value) => value.list);

    String appBarTitle = isAppInitializedFailed == false
        ? mainProvider.mainScreenTitle
        : AppLocalizations.of(context)?.initializationFailed ??
            "Initialization failed";

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              jumpScrollPositionToTop(_scrollController);
            },
            child: Text(appBarTitle)),
        flexibleSpace: GestureDetector(
          onTap: () {
            jumpScrollPositionToTop(_scrollController);
          },
        ),
      ),
      body: isAppInitializedFailed == false
          ? Center(
              child: Column(
                children: [
                  conditionSelectWidget(context, mainProvider),
                  Expanded(child: listView(context, mainProvider, list))
                ],
              ),
            )
          : initFailedWidget(context),
      drawer: drawer(),
    );
  }
}
