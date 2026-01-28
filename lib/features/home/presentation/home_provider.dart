import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/data/photo_repository.dart';
import 'package:pinterest_clone/features/home/domain/photo_model.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, List<PhotoModel>>((ref) {
  return HomeNotifier();
});

class HomeNotifier extends StateNotifier<List<PhotoModel>> {
  HomeNotifier() : super([]);

  final PhotoRepository repo = PhotoRepository();
  int page = 1;

  Future<void> loadPhotos() async {
    final data = await repo.getPhotos(page);
    state = [...state, ...data];
    page++;
  }
}
