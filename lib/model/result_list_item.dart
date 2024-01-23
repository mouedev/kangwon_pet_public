import '../const.dart';

class ResultListItem {
  final int contentSeq;
  final String areaName;
  final String partName;
  final String title;
  final String address;
  final String latitude;
  final String longitude;
  final String tel;

  ResultListItem(
      {required this.contentSeq,
      required this.areaName,
      required this.partName,
      required this.title,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.tel});

  factory ResultListItem.fromJson(Map<String, dynamic> json) {
    return ResultListItem(
      contentSeq: json[JsonMapKey.contentSeq.key] as int,
      areaName: json[JsonMapKey.areaName.key] as String,
      partName: json[JsonMapKey.partName.key] as String,
      title: json[JsonMapKey.title.key] as String,
      address: json[JsonMapKey.address.key] as String,
      latitude: json[JsonMapKey.latitude.key] as String,
      longitude: json[JsonMapKey.longitude.key] as String,
      tel: json['tel'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      JsonMapKey.contentSeq.key: contentSeq,
      JsonMapKey.areaName.key: areaName,
      JsonMapKey.partName.key: partName,
      JsonMapKey.title.key: title,
      JsonMapKey.address.key: address,
      JsonMapKey.latitude.key: latitude,
      JsonMapKey.longitude.key: longitude,
      JsonMapKey.tel.key: tel
    };
  }

  Map<String, dynamic> toListItemMap() {
    return {
      JsonMapKey.areaName.key: areaName,
      JsonMapKey.partName.key: partName,
      JsonMapKey.title.key: title,
      JsonMapKey.address.key: address,
      JsonMapKey.tel.key: tel
    };
  }

  @override
  String toString() {
    return "ListPartData class \n"
        "contentSeq : $contentSeq \n"
        "areaName : $areaName "
        "partName : $partName "
        "title : $title "
        "address : $address "
        "latitude : $latitude "
        "longitude : $longitude "
        "tel : $tel";
  }
}
