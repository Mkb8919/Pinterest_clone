import 'search_api_service.dart';
import 'package:pinterest_clone/features/home/domain/photo_model.dart';

class SearchRepository {
  final SearchApiService api = SearchApiService();

  Future<List<PhotoModel>> getSearchPhotos(String query, int page) {
    return api.searchPhotos(query, page);
  }
}
