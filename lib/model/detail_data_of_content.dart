import '../const.dart';

class DetailDataOfContent {
  final int contentSeq;
  final String areaName;
  final String partName;
  final String title;
  final String keyword;
  final String address;
  final String tel;
  final String latitude;
  final String longitude;
  final String usedTime;
  final String homePage;
  final String content;
  final String provisionSupply;
  final String petFacility;
  final String restaurant;
  final String parkingLot;
  final String mainFacility;
  final String usedCost;
  final String policyCautions;
  final String emergencyResponse;
  final String memo;
  final String bathFlag;
  final String provisionFlag;
  final String petFlag;
  final String petWeight;
  // final String petBreed;
  final String emergencyFlag;
  final String entranceFlag;
  final String parkingFlag;
  final String inOutFlag;
  final List<String> imageList;

  DetailDataOfContent(
      {required this.contentSeq,
      required this.areaName,
      required this.partName,
      required this.title,
      required this.keyword,
      required this.address,
      required this.tel,
      required this.latitude,
      required this.longitude,
      required this.usedTime,
      required this.homePage,
      required this.content,
      required this.provisionSupply,
      required this.petFacility,
      required this.restaurant,
      required this.parkingLot,
      required this.mainFacility,
      required this.usedCost,
      required this.policyCautions,
      required this.emergencyResponse,
      required this.memo,
      required this.bathFlag,
      required this.provisionFlag,
      required this.petFlag,
      required this.petWeight,
      // required this.petBreed,
      required this.emergencyFlag,
      required this.entranceFlag,
      required this.parkingFlag,
      required this.inOutFlag,
      required this.imageList});

  DetailDataOfContent.empty()
      : contentSeq = -1,
        areaName = "",
        partName = "",
        title = "",
        keyword = "",
        address = "",
        tel = "",
        latitude = "",
        longitude = "",
        usedTime = "",
        homePage = "",
        content = "",
        provisionSupply = "",
        petFacility = "",
        restaurant = "",
        parkingLot = "",
        mainFacility = "",
        usedCost = "",
        policyCautions = "",
        emergencyResponse = "",
        memo = "",
        bathFlag = "",
        provisionFlag = "",
        petFlag = "",
        petWeight = "",
        // petBreed = "",
        emergencyFlag = "",
        entranceFlag = "",
        parkingFlag = "",
        inOutFlag = "",
        imageList = List.empty();

  bool isEmpty() => contentSeq == -1;

  factory DetailDataOfContent.fromJson(Map<String, dynamic> json) {
    var deserializableImageList = json[JsonMapKey.imageList.key] == null
        ? null
        : json['imageList'] as List;
    return DetailDataOfContent(
      contentSeq: json[JsonMapKey.contentSeq.key] as int,
      areaName: json[JsonMapKey.areaName.key] as String,
      partName: json[JsonMapKey.partName.key] as String,
      title: json[JsonMapKey.title.key] as String,
      keyword: json['keyword'] as String,
      address: json[JsonMapKey.address.key] as String,
      tel: json[JsonMapKey.tel.key] as String,
      latitude: json[JsonMapKey.latitude.key] as String,
      longitude: json[JsonMapKey.longitude.key] as String,
      usedTime: json[JsonMapKey.usedTime.key] as String,
      homePage: json[JsonMapKey.homePage.key] as String,
      content: json[JsonMapKey.content.key] as String,
      provisionSupply: json[JsonMapKey.provisionSupply.key] as String,
      petFacility: json[JsonMapKey.petFacility.key] as String,
      restaurant: json[JsonMapKey.restaurant.key] as String,
      parkingLot: json[JsonMapKey.parkingLot.key] == null
          ? ''
          : json[JsonMapKey.parkingLot.key] as String,
      mainFacility: json[JsonMapKey.mainFacility.key] as String,
      usedCost: json[JsonMapKey.usedCost.key] as String,
      policyCautions: json[JsonMapKey.policyCautions.key] as String,
      emergencyResponse: json[JsonMapKey.emergencyResponse.key] as String,
      memo: json[JsonMapKey.memo.key] as String,
      bathFlag: json[JsonMapKey.bathFlag.key] == null
          ? ''
          : json[JsonMapKey.bathFlag.key] as String,
      provisionFlag: json[JsonMapKey.provisionFlag.key] == null
          ? ''
          : json[JsonMapKey.provisionFlag.key] as String,
      petFlag: json[JsonMapKey.petFlag.key] == null
          ? ''
          : json[JsonMapKey.petFlag.key] as String,
      petWeight: json[JsonMapKey.petWeight.key] as String,
      // petBreed: json['petBreed'] == null ? '' : json['petBreed'] as String,
      emergencyFlag: json[JsonMapKey.emergencyFlag.key] == null
          ? ''
          : json[JsonMapKey.emergencyFlag.key] as String,
      entranceFlag: json[JsonMapKey.entranceFlag.key] == null
          ? ''
          : json[JsonMapKey.entranceFlag.key] as String,
      parkingFlag: json[JsonMapKey.parkingFlag.key] == null
          ? ''
          : json[JsonMapKey.parkingFlag.key] as String,
      inOutFlag: json[JsonMapKey.inOutFlag.key] == null
          ? ''
          : json[JsonMapKey.inOutFlag.key] as String,
      imageList: deserializableImageList == null
          ? List.empty()
          : deserializableImageList
              .map((i) => (i)[JsonMapKey.image.key] as String)
              .toList(),
    );
  }

  @override
  String toString() {
    return "DetailSequencePartData class "
        "contentSeq : $contentSeq "
        "areaName : $areaName "
        "partName : $partName "
        "title : $title "
        "keyword : $keyword"
        "address : $address "
        "tel : $tel"
        "latitude : $latitude "
        "longitude : $longitude "
        "usedTime : $usedTime "
        "homePage : $homePage "
        "content : $content "
        "provisionSupply : $provisionSupply "
        "petFacility : $petFacility "
        "restaurant : $restaurant "
        "parkingLot : $parkingLot "
        "mainFacility : $mainFacility "
        "usedCost : $usedCost "
        "policyCautions : $policyCautions "
        "emergencyResponse : $emergencyResponse "
        "memo : $memo "
        "bathFlag : $bathFlag "
        "petWeight : $petWeight "
        // "petBreed : $petBreed "
        "emergencyFlag : $emergencyFlag "
        "entranceFlag : $entranceFlag "
        "parkingFlag : $parkingFlag "
        "inOutFlag : $inOutFlag "
        "imageList size : ${imageList.length} ";
  }
}
