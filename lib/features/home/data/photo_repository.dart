import 'photo_api_service.dart';
import '../domain/photo_model.dart';

class PhotoRepository {
  final PhotoApiService api = PhotoApiService();

  Future<List<PhotoModel>> getPhotos(int page) {
    return api.fetchPhotos(page);
  }
}
