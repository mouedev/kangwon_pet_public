class ImageData {
  final String path;

  ImageData({
    required this.path,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      path: json['image'] as String,
    );
  }
}
