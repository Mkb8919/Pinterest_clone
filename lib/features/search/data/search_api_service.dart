import 'package:dio/dio.dart';
import 'package:pinterest_clone/core/services/dio_client.dart';
import 'package:pinterest_clone/features/home/domain/photo_model.dart';

class SearchApiService {
  final DioClient _client = DioClient();

  Future<List<PhotoModel>> searchPhotos(String query, int page) async {
    final response = await _client.client.get(
      "search?query=$query&per_page=30&page=$page",
    );

    List photos = response.data["photos"];
    return photos.map((p) => PhotoModel.fromJson(p)).toList();
  }
}
