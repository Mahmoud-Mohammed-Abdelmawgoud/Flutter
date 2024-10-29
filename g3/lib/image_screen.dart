import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class ImageScreen extends StatelessWidget {
  final String imagePath;

  ImageScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: InstaImageViewer(
                child: Image.network(
                  'https://image.tmdb.org/t/p/original$imagePath',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Function to download the image
                  },
                  child: Text('Download'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Function for zoom if needed
                  },
                  child: Text('Zoom'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
