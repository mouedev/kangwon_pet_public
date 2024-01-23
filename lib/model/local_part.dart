import 'package:kangwon_pet/model/result_list_item.dart';

class LocalPart {
  List<ResultListItem> resultList;
  final int totalCount;
  final String message;

  LocalPart({
    required this.resultList,
    required this.totalCount,
    required this.message,
  });

  factory LocalPart.fromJson(Map<String, dynamic> json) {
    var deserializableList = json['resultList'] as List;
    return LocalPart(
      resultList:
          deserializableList.map((i) => ResultListItem.fromJson(i)).toList(),
      totalCount: json['totalCount'] as int,
      message: json['message'] as String,
    );
  }
}
