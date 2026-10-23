import 'package:flutter/material.dart';
import '../data/content.dart';
import 'widgets.dart';

class MiniGallery extends StatelessWidget {
  const MiniGallery({super.key, required this.images});
  final List<String> images;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 90,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: images.length,
      separatorBuilder: (_, i) => const SizedBox(width: 15),
      itemBuilder: (_, i) => SizedBox(
        width: 140,
        child: ArtTile(Artwork(images[i], 'Concept study', images[i])),
      ),
    ),
  );
}
