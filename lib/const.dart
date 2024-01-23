enum JsonMapKey {
  contentSeq("contentSeq", "contentSeq"),
  areaName("areaName", "지역"),
  partName("partName", "분야"),
  title("title", "업체명"),
  address("address", "주소"),
  latitude("latitude", "latitude"),
  longitude("longitude", "longitude"),
  tel("tel", "전화번호"),
  usedTime("usedTime", "사용시간"),
  homePage("homePage", "홈페이지"),
  provisionSupply("provisionSupply", "비품제공"),
  content("content", "소개"),
  petFacility("petFacility", "반려동물 시설"),
  restaurant("restaurant", "식당"),
  parkingLot("parkingLot", "주차장 수용"),
  mainFacility("mainFacility", "주요시설"),
  usedCost("usedCost", "이용요금"),
  policyCautions("policyCautions", "애견정책 및 주의사항"),
  emergencyResponse("emergencyResponse", "응급상황 대처 여부"),
  memo("memo", "기타"),
  bathFlag("bathFlag", "목욕시설 (Y/N)"),
  provisionFlag("provisionFlag", "비품제공 (Y/N)"),
  petFlag("petFlag", "펫 동반식당 (Y/N)"),
  petWeight("petWeight", "제한 몸무게 (kg)"),
  emergencyFlag("emergencyFlag", "응급 수칙 (Y/N)"),
  entranceFlag("entranceFlag", "입장료 (Y/N)"),
  parkingFlag("parkingFlag", "주차장 (Y/N)"),
  inOutFlag("inOutFlag", "실내외 구분 (IN/OUT)"),
  imageList("imageList", ""),
  image("image", ""),
  undefined("undefined", "");

  const JsonMapKey(this.key, this.displayName);
  final String key;
  final String displayName;

  factory JsonMapKey.getByCode(String code) {
    return JsonMapKey.values.firstWhere((value) => value.key == code,
        orElse: () => JsonMapKey.undefined);
  }
}

enum PartCode {
  touristAttraction("touristAttraction", "PC03", "관광지"),
  accommodation("accommodation", "PC02", "숙박"),
  beverage("beverage", "PC01", "식음료"),
  experience("experience", "PC04", "체험"),
  veterinaryClinic("veterinaryClinic", "PC05", "동물병원");
  // undefined("undefined", "");

  const PartCode(this.name, this.code, this.displayName);
  final String name;
  final String code;
  final String displayName;
  //
  // factory PartCode.getByCode(String code) {
  //   return PartCode.values.firstWhere((value) => value.code == code,
  //       orElse: () => PartCode.undefined);
  // }
}

enum LocalCode {
  chuncheon("chuncheon", "AC01", "춘천시"),
  wonju("wonju", "AC02", "원주시"),
  gangleung("gangleung", "AC03", "강릉시"),
  donghae("donghae", "AC04", "동해시"),
  taebaek("taebaek", "AC05", "태백시"),
  sokcho("sokcho", "AC06", "속초시"),
  samcheok("samcheok", "AC07", "삼척시"),
  hongcheon("hongcheon", "AC08", "홍천군"),
  hwengsung("hwengsung", "AC09", "횡성군"),
  youngwol("youngwol", "AC10", "영월군"),
  pyeongchang("pyeongchang", "AC11", "평창군"),
  jungsun("jungsun", "AC12", "정선군"),
  cheolwon("cheolwon", "AC13", "철원군"),
  hwacheon("hwacheon", "AC14", "화천군"),
  yangku("yangku", "AC15", "양구군"),
  inje("inje", "AC16", "인제군"),
  gosung("gosung", "AC17", "고성군"),
  yangyang("yangyang", "AC18", "양양군");
  // undefined("undefined", "");

  const LocalCode(this.name, this.code, this.displayName);
  final String name;
  final String code;
  final String displayName;

  // factory LocalCode.getByCode(String code) {
  //   return LocalCode.values.firstWhere((value) => value.code == code,
  //       orElse: () => LocalCode.undefined);
  // }
}

const int listPageBlockCount = 20;

enum ListLoadState {
  none,
  requestedToLoadMore,
  loading,
  loaded,
  failed,
  reachedToMaxCount
}

enum DetainContentLoadState { loading, loaded, failed }

enum ListType {
  part("part", "분야"),
  local("local", "지역");

  const ListType(this.name, this.displayName);
  final String name;
  final String displayName;
}

const int networkTimeOutDurationSec = 3;
