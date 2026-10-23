import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_controller.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';
import '../profile/profile_page.dart';
import '../work/work_page.dart';
import '../work/work_actions.dart';
import '../../core/art_gallery.dart';
import 'filter_sheet.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (app.feedMode == FeedMode.activity) return const ActivityPage();
    final recommended = app.feedMode == FeedMode.recommended;
    return Stack(
      children: [
        ListView(
          key: ValueKey(app.feedMode),
          padding: EdgeInsets.zero,
          children: [
            PageHeader(
              title: app.feedMode.label,
              eyebrow: recommended
                  ? 'You have: 13 new followers'
                  : 'Since last visit: 24 new publishes',
              onTitleTap: () => showFeedFilter(context),
            ),
            if (recommended)
              const RecommendedFeed()
            else ...[
              const StoryStrip(),
              if (app.grid)
                const ArtGrid(newWorks)
              else
                ...newWorks.map(
                  (art) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ArtistRow(art.creator),
                        const SizedBox(height: 12),
                        AspectRatio(aspectRatio: 1.55, child: ArtTile(art)),
                        const SizedBox(height: 10),
                        Text(art.title),
                        const Divider(height: 24),
                      ],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 38),
          ],
        ),
        if (!recommended)
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: Center(
              child: Semantics(
                label: 'Filter feed',
                button: true,
                child: GestureDetector(
                  key: const ValueKey('feed-filter'),
                  onTap: () => showFeedFilter(context),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: Palette.blueGradient,
                      boxShadow: [
                        BoxShadow(color: Color(0x30303A44), blurRadius: 16),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.slider_horizontal_3,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class StoryStrip extends StatelessWidget {
  const StoryStrip({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    decoration: const BoxDecoration(
      color: Color(0x14303A44),
      border: Border(bottom: BorderSide(color: Palette.line, width: .5)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...[
          'sanna',
          'story2',
          'story3',
          'story4',
          'story5',
        ].asMap().entries.map(
          (entry) => Avatar(
            entry.value,
            size: entry.key.isEven ? 46 : 40,
            story: entry.key == 0 || entry.key == 3,
            onTap: () =>
                pushPage(context, ProfilePage(artist: creatives[entry.key])),
          ),
        ),
        IconButton(
          tooltip: 'Browse creatives',
          onPressed: () => showFeedFilter(context),
          icon: const Icon(
            CupertinoIcons.chevron_right,
            color: Palette.muted,
            size: 22,
          ),
        ),
      ],
    ),
  );
}

class RecommendedFeed extends StatelessWidget {
  const RecommendedFeed({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: const BoxDecoration(
          color: Color(0x16303A44),
          border: Border(bottom: BorderSide(color: Palette.line)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ArtistRow(
                brad,
                subtitle: brad.role,
                trailing: const FollowButton(brad),
              ),
            ),
            const SizedBox(height: 15),
            const MiniGallery(images: ['dragon_fire', 'golem', 'more2']),
            const SizedBox(height: 9),
            TextButton(
              onPressed: () => showFeedFilter(context),
              child: const Column(
                children: [
                  Text(
                    'See more creatives',
                    style: TextStyle(fontSize: 11, color: Palette.muted),
                  ),
                  SizedBox(height: 3),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 13,
                    color: Palette.muted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArtistRow(frank, trailing: MoreButton()),
            const SizedBox(height: 12),
            const Text(
              'Abduction!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 335 / 215,
              child: GestureDetector(
                key: const ValueKey('recommended-work'),
                onTap: () => pushPage(context, const WorkPage(art: abduction)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: const Stack(
                    fit: StackFit.expand,
                    children: [
                      ArtImage('abduction', fit: BoxFit.cover),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Row(
                          children: [
                            MediaBadge(CupertinoIcons.play_fill),
                            SizedBox(width: 8),
                            MediaBadge(
                              CupertinoIcons.square_fill_on_square_fill,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const WorkActions(art: abduction, showViews: true),
          ],
        ),
      ),
    ],
  );
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      PageHeader(
        title: 'Activity',
        eyebrow: 'You follow: 184 creatives',
        onTitleTap: () => showFeedFilter(context),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArtistRow(
              mandy,
              subtitle: 'liked 8 publishes',
              trailing: MoreButton(),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 163,
              child: Row(
                children: [
                  Expanded(
                    child: ArtTile(
                      const Artwork(
                        'activity1',
                        'A new adventure',
                        'activity1',
                        is3d: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ArtTile(
                      const Artwork('activity2', 'Ghost stories', 'activity2'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30),
            const ArtistRow(
              sanna,
              subtitle: 'now following 3 creatives',
              trailing: MoreButton(),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Avatar(
                  'me',
                  onTap: () => pushPage(context, const ProfilePage()),
                ),
                const SizedBox(width: 20),
                Avatar(
                  'mandy',
                  onTap: () =>
                      pushPage(context, const ProfilePage(artist: mandy)),
                ),
                const SizedBox(width: 20),
                Avatar(
                  'story3',
                  onTap: () =>
                      pushPage(context, const ProfilePage(artist: brad)),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'View following',
                  onPressed: () => showFeedFilter(context),
                  icon: const Icon(
                    CupertinoIcons.chevron_right,
                    color: Palette.muted,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            const ArtistRow(
              greg,
              subtitle: 'collected 1 publish in Concept Arts',
              trailing: MoreButton(),
            ),
            const SizedBox(height: 15),
            AspectRatio(
              aspectRatio: 335 / 215,
              child: ArtTile(
                const Artwork('sorceress', 'Emerald Sorceress', 'sorceress'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
