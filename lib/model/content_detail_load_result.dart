import 'package:kangwon_pet/model/detail_data_of_content.dart';

class ContentDetailLoadResult {
  DetailDataOfContent detailDataOfContent;
  final int totalCount;
  final String message;
  final int httpStatusCode;

  ContentDetailLoadResult({
    required this.detailDataOfContent,
    required this.totalCount,
    required this.message,
    required this.httpStatusCode,
  });

  ContentDetailLoadResult.error({required this.message,required this.httpStatusCode})
      : detailDataOfContent = DetailDataOfContent.empty(),
        totalCount = 0;

  factory ContentDetailLoadResult.fromJson(Map<String, dynamic> json,int httpStatusCode) {
    var resultList = json['resultList'] as Map<String, dynamic>;
    return ContentDetailLoadResult(
      detailDataOfContent: DetailDataOfContent.fromJson(resultList),
      totalCount: json['totalCount'] == null ? 0 : json['totalCount'] as int,
      message: json['message'] as String, httpStatusCode: httpStatusCode,
    );
  }
}
