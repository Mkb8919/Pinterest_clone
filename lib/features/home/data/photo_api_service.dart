import 'package:dio/dio.dart';
import 'package:pinterest_clone/core/services/dio_client.dart';
import 'package:pinterest_clone/features/home/domain/photo_model.dart';

class PhotoApiService {
  final DioClient _client = DioClient();

  Future<List<PhotoModel>> fetchPhotos(int page) async {
    final response = await _client.client.get(
      "curated?per_page=20&page=$page",
    );

    List photos = response.data["photos"];

    return photos.map((p) => PhotoModel.fromJson(p)).toList();
  }
}
