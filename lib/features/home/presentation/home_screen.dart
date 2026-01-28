import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/core/widgets/shimmer_box.dart';
import 'package:pinterest_clone/features/home/presentation/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/image_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load initial photos
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadPhotos();
    });

    // Infinite scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(homeProvider.notifier).loadPhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(homeProvider); // REAL DATA from API

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Pinterest",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 30),
            onPressed: () {},
          )
        ],
      ),

      body: photos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : MasonryGridView.count(
        controller: _scrollController,
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ImageDetailsScreen(imageUrl: photo.url),
                ),
              );
            },
            child: Hero(
              tag: photo.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  photo.url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 400),
                        child: child,
                      );
                    }

                    return ShimmerBox(
                      height: (index % 2 == 0) ? 250 : 350,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
