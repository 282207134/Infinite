import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';
import '../work/work_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ListView(
        padding: EdgeInsets.zero,
        children: [
          const PageHeader(
            title: 'Explore',
            eyebrow: 'Excellent Skill: You’re in Trending',
          ),
          const SizedBox(height: 14),
          const Center(
            child: Icon(
              CupertinoIcons.chevron_left_slash_chevron_right,
              size: 30,
              color: Palette.blue,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Livestream',
                  style: TextStyle(fontSize: 11, color: Palette.blue),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Cinema 4D: Lighting Techniques',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 5),
                const Text(
                  '▥ 1 054 watching now',
                  style: TextStyle(fontSize: 11, color: Palette.muted),
                ),
                const SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 335 / 215,
                  child: GestureDetector(
                    key: const ValueKey('livestream'),
                    onTap: () => pushPage(
                      context,
                      const WorkPage(
                        art: Artwork(
                          'livestream',
                          'Cinema 4D: Lighting Techniques',
                          'livestream',
                          video: true,
                        ),
                        startVideo: true,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const ArtImage('livestream'),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Avatar('host', size: 24),
                                  SizedBox(width: 5),
                                  Text(
                                    '• Live',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ArtistRow(
                  Creative('eric', 'Eric Braddock', 'Concept Artist', 'eric'),
                  trailing: MoreButton(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'KSU',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const AspectRatio(
                  aspectRatio: 335 / 215,
                  child: ArtTile(Artwork('dragon', 'KSU', 'dragon')),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        bottom: 24,
        left: 0,
        right: 0,
        child: Center(
          child: GradientButton(
            label: 'Fresh ↑',
            green: true,
            width: 105,
            onTap: () =>
                notice(context, 'You’re up to date with the latest publishes.'),
          ),
        ),
      ),
    ],
  );
}
