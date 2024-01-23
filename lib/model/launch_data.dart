class LaunchData {
  final String? _title;
  final String? _tel;
  final String? _address;
  final String? _latitude;
  final String? _longitude;
  final String? _homePage;

  LaunchData(
      {String? title,
      String? tel,
      String? address,
      String? latitude,
      String? longitude,
      String? homePage})
      : _title = title,
        _tel = tel,
        _address = address,
        _latitude = latitude,
        _longitude = longitude,
        _homePage = homePage;

  String? get title => _title;
  String? get tel => _tel;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get homePage => _homePage;

  bool hasMapData() {
    return (_title?.isNotEmpty ?? false) &&
        (_address?.isNotEmpty ?? false) &&
        (_latitude?.isNotEmpty ?? false) &&
        (_longitude?.isNotEmpty ?? false);
  }

  String? get validTextToShow {
    if (_tel?.isNotEmpty ?? false) {
      return _tel;
    } else if (_homePage?.isNotEmpty ?? false) {
      return _homePage;
    } else if (hasMapData() == true) {
      return _address;
    }

    return null;
  }
}
