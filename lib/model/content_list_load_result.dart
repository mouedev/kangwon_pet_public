import 'package:kangwon_pet/model/result_list_item.dart';

class ContentListLoadResult {
  List<ResultListItem> resultList;
  final int totalCount;
  final String message;
  final int httpStatusCode;

  ContentListLoadResult({
    required this.resultList,
    required this.totalCount,
    required this.message,
    required this.httpStatusCode,
  });

  ContentListLoadResult.error({required this.message,required this.httpStatusCode})
      : resultList = List.empty(),
        totalCount = 0;

  factory ContentListLoadResult.fromJson(Map<String, dynamic> json,int httpStatusCode) {
    var deserializableList = json['resultList'] as List;
    return ContentListLoadResult(
      resultList:
          deserializableList.map((i) => ResultListItem.fromJson(i)).toList(),
      totalCount: json['totalCount'] as int,
      message: json['message'] as String,
      httpStatusCode: httpStatusCode
    );
  }
}
