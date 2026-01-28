class PhotoModel {
  final int id;
  final String url;

  PhotoModel({
    required this.id,
    required this.url,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      url: json['src']['medium'],  // API se medium size image aa rahi
    );
  }
}
