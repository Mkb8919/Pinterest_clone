import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/domain/photo_model.dart';
import 'package:pinterest_clone/features/search/data/search_repository.dart';

final searchProvider =
StateNotifierProvider<SearchNotifier, List<PhotoModel>>((ref) {
  return SearchNotifier();
});

class SearchNotifier extends StateNotifier<List<PhotoModel>> {
  SearchNotifier() : super([]);

  final SearchRepository repo = SearchRepository();
  int page = 1;

  Future<void> searchImages(String query) async {
    page = 1;
    state = [];
    final data = await repo.getSearchPhotos(query, page);
    state = [...state, ...data];
    page++;
  }

  Future<void> loadMore(String query) async {
    final data = await repo.getSearchPhotos(query, page);
    state = [...state, ...data];
    page++;
  }
}
