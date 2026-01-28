import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pinterest_clone/core/widgets/shimmer_box.dart';
import 'package:pinterest_clone/features/home/presentation/image_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];
  bool isLoading = false;
  bool isError = false;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.pexels.com/v1/",
      headers: {
        "Authorization": "yzqnHbzYP2tCetw0OZIvrA0RkDUln8pGe2pHP4W5v9sHoRI9Y8k3TeNi ", // ← Replace your API key
      },
    ),
  );

  Future<void> fetchSearchResults(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      isError = false;
      searchResults.clear();
    });

    try {
      final response = await dio.get("search", queryParameters: {
        "query": query,
        "per_page": 40,
      });

      final List photos = response.data["photos"];

      setState(() {
        searchResults = photos.map<String>((p) => p["src"]["medium"]).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onSubmitted: fetchSearchResults,
              decoration: InputDecoration(
                hintText: "Search wallpapers, ideas...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),

          Expanded(
            child: buildSearchContent(),
          ),
        ],
      ),
    );
  }

  Widget buildSearchContent() {
    if (isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (_, i) => const ShimmerBox(height: 200),
      );
    }

    if (isError) {
      return const Center(
        child: Text(
          "Something went wrong, try again!",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          "Start searching...",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: searchResults.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        final img = searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageDetailsScreen(imageUrl: img),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
