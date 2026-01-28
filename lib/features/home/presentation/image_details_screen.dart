import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:pinterest_clone/core/services/save_service.dart';

class ImageDetailsScreen extends StatelessWidget {
  final String imageUrl;

  const ImageDetailsScreen({super.key, required this.imageUrl});

  // ---------------------------
  // DOWNLOAD IMAGE (FOR ANDROID)
  // ---------------------------
  Future<void> downloadImage(String imageUrl, BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          "${tempDir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Download image with Dio
      await Dio().download(imageUrl, filePath);

      // Save using Android MediaStore via MethodChannel
      await const MethodChannel("save_image_channel").invokeMethod(
        "saveImage",
        {"filePath": filePath},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Saved to Gallery 🎉"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Download Failed ❌"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------------------------
  // BUILD UI
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          // IMAGE DISPLAY
          Center(
            child: Hero(
              tag: imageUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // SAVE BUTTON
          Positioned(
            bottom: 100,
            right: 20,
            child: StatefulBuilder(
              builder: (context, setState) {
                bool alreadySaved = SaveService.isSaved(imageUrl);

                return FloatingActionButton(
                  backgroundColor: Colors.white,
                  heroTag: "save_btn",
                  onPressed: () async {
                    if (alreadySaved) {
                      await SaveService.removePin(imageUrl);
                      setState(() => alreadySaved = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Removed from Saved"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      await SaveService.savePin(imageUrl);
                      setState(() => alreadySaved = true);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Saved to Profile"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Icon(
                    alreadySaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),

          // DOWNLOAD BUTTON
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: "download_btn",
              onPressed: () => downloadImage(imageUrl, context),
              child: const Icon(Icons.download, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
