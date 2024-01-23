import 'package:flutter/cupertino.dart';
import 'package:kangwon_pet/const.dart';
import 'package:kangwon_pet/model/detail_data_of_content.dart';

import 'model/result_list_item.dart';

class MainProvider with ChangeNotifier {
  final List<ResultListItem> _list = List.empty(growable: true);
  DetailDataOfContent? _detailDataOfContent;
  PartCode _partCode = PartCode.experience;
  LocalCode _localCode = LocalCode.wonju;
  int _pageNum = 0;
  int _listTotalCount = 0;
  ListType _listType = ListType.part;
  String _mainSecreenTitle = "Flutter Demo";

  set listType(ListType value) {
    _listType = value;
  }

  ListType get listType => _listType;

  addList(List<ResultListItem> partList) {
    _list.addAll(partList);
    notifyListeners();
  }

  List<ResultListItem> get list => _list;

  clearList({bool notify = false}) {
    _list.clear();
    if (notify) {
      notifyListeners();
    }
  }

  set detailDataOfContent(DetailDataOfContent value) {
    _detailDataOfContent = value;
    notifyListeners();
  }

  DetailDataOfContent? get detailSequencePartData => _detailDataOfContent;

  set partCode(PartCode partCode) {
    _partCode = partCode;
  }

  PartCode get partCode => _partCode;

  set localCode(LocalCode localCode) {
    _localCode = localCode;
  }

  LocalCode get localCode => _localCode;

  set pageNum(int pageNum) {
    _pageNum = pageNum;
  }

  int get pageNum => _pageNum;

  set listTotalCount(int listTotalCount) {
    _listTotalCount = listTotalCount;
  }

  int get listTotalCount => _listTotalCount;

  set mainScreenTitle(String title) {
    _mainSecreenTitle = title;
    notifyListeners();
  }

  String get mainScreenTitle => _mainSecreenTitle;

  @override
  String toString() {
    String log = "MainProvider _partList length : ${_list.length}";
    if (_detailDataOfContent != null) {
      log += " _detailSequencePartData : $_detailDataOfContent";
    } else {
      log += " _detailSequencePartData is NULL";
    }
    return log;
  }
}
