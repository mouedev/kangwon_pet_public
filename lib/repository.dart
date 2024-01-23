import 'dart:async';
import 'dart:convert';

import 'package:kangwon_pet/model/content_list_load_result.dart';
import 'package:kangwon_pet/model/content_detail_load_result.dart';
import 'package:http/http.dart' as http;

import 'const.dart';

Future<ContentListLoadResult> loadListFromRepository(
    ListType listType, int pageNum,
    {PartCode partCode = PartCode.accommodation,
    LocalCode localCode = LocalCode.wonju,
    int duration = networkTimeOutDurationSec}) async {
  int page = pageNum * listPageBlockCount; //It's to solve API's error.
  ContentListLoadResult? contentListLoadResult;
  int httpStatusCode = -1;
  try {
    http.Client client = http.Client();
    String url = listType == ListType.part
        ? "https://www.pettravel.kr/api/listPart.do?page=$page&pageBlock=$listPageBlockCount&partCode=${partCode.code}"
        : "https://www.pettravel.kr/api/listArea.do?page=$page&pageBlock=$listPageBlockCount&areaCode=${localCode.code}";

    Uri uri = Uri.parse(url);
    http.Response response = await client.get(uri).timeout(
      Duration(seconds: duration),
      onTimeout: () {
        return http.Response(
            'Timeout Error', 408); // Request Timeout response status code
      },
    );
    httpStatusCode = response.statusCode;
    final List<dynamic> jsonArray = json.decode(response.body);

    bool loadSucceeded = response.statusCode == 200;
    bool validJsonArrayLength = jsonArray.isNotEmpty;
    bool deserialize = loadSucceeded && validJsonArrayLength;

    if (deserialize) {
      final jsonMap = jsonArray[0];
      contentListLoadResult =
          ContentListLoadResult.fromJson(jsonMap, httpStatusCode);
    }
  } on TimeoutException catch (_) {
    contentListLoadResult = ContentListLoadResult.error(
        message: "Timeout error", httpStatusCode: httpStatusCode);
  } on Exception catch (exception) {
    contentListLoadResult = ContentListLoadResult.error(
        message: exception.toString(), httpStatusCode: httpStatusCode);
  } finally {
    contentListLoadResult ??= ContentListLoadResult.error(
        message: "Unknown error", httpStatusCode: httpStatusCode);
  }

  return contentListLoadResult;
}

Future<ContentDetailLoadResult> loadDetailOfItemFromRepository(
    ListType listType, PartCode partCode, LocalCode localCode, int contentNum,
    {int duration = networkTimeOutDurationSec}) async {
  ContentDetailLoadResult? contentDetailLoadResult;
  int httpStatusCode = -1;
  try {
    http.Client client = http.Client();
    String url = listType == ListType.part
        ? "https://www.pettravel.kr/api/detailSeqPart.do?partCode=${partCode.code}&contentNum=$contentNum"
        : "https://www.pettravel.kr/api/detailSeqArea.do?areaCode=${localCode.code}&contentNum=$contentNum";
    Uri uri = Uri.parse(url);
    http.Response response = await client.get(uri).timeout(
      Duration(seconds: duration),
      onTimeout: () {
        return http.Response(
            'Timeout Error', 408); // Request Timeout response status code
      },
    );

    httpStatusCode = response.statusCode;
    final List<dynamic> jsonArray = json.decode(response.body);

    bool loadSucceeded = response.statusCode == 200;
    bool validJsonArrayLength = jsonArray.isNotEmpty;
    bool deserialize = loadSucceeded && validJsonArrayLength;
    if (deserialize) {
      final jsonMap = jsonArray[0];
      contentDetailLoadResult =
          ContentDetailLoadResult.fromJson(jsonMap, httpStatusCode);
    }
  } on TimeoutException catch (_) {
    contentDetailLoadResult = ContentDetailLoadResult.error(
        message: "error", httpStatusCode: httpStatusCode);
  } on Exception catch (exception) {
    contentDetailLoadResult = ContentDetailLoadResult.error(
        message: exception.toString(), httpStatusCode: httpStatusCode);
  } finally {
    contentDetailLoadResult ??= ContentDetailLoadResult.error(
        message: "Unknown error", httpStatusCode: httpStatusCode);
  }

  return contentDetailLoadResult;
}
