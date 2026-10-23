import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app/app_scope.dart';
import '../data/content.dart';
import 'theme.dart';

void pushPage(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
void openArtist(BuildContext context, Creative artist) =>
    Navigator.of(context).pushNamed('/artist', arguments: artist);
void openWork(BuildContext context, Artwork art) =>
    Navigator.of(context).pushNamed('/work', arguments: art);
void openChat(BuildContext context) => Navigator.of(context).pushNamed('/chat');

void notice(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
  );

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(gradient: Palette.background),
    child: child,
  );
}

class ArtImage extends StatelessWidget {
  const ArtImage(
    this.name, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });
  final String name;
  final BoxFit fit;
  final double? width, height;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.webp',
    fit: fit,
    width: width,
    height: height,
    excludeFromSemantics: true,
  );
}

class Avatar extends StatelessWidget {
  const Avatar(
    this.name, {
    super.key,
    this.size = 40,
    this.story = false,
    this.onTap,
  });
  final String name;
  final double size;
  final bool story;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Open artist profile',
    button: onTap != null,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(story ? 2 : 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: story ? Border.all(color: Palette.orange, width: 2) : null,
        ),
        child: ClipOval(child: ArtImage(name)),
      ),
    ),
  );
}

class VerifiedName extends StatelessWidget {
  const VerifiedName(
    this.name, {
    super.key,
    this.verified = true,
    this.size = 15,
  });
  final String name;
  final bool verified;
  final double size;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w500),
        ),
      ),
      if (verified) ...[
        const SizedBox(width: 5),
        const CircleAvatar(
          radius: 8,
          backgroundColor: Palette.orange,
          child: Icon(Icons.check, size: 11, color: Colors.white),
        ),
      ],
    ],
  );
}

class ArtistRow extends StatelessWidget {
  const ArtistRow(
    this.artist, {
    super.key,
    this.subtitle = '15 June, at 09:41',
    this.trailing,
    this.onTap,
  });
  final Creative artist;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    void open() => onTap != null ? onTap!() : openArtist(context, artist);
    return Row(
      children: [
        Avatar(artist.avatar, onTap: open),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: open,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerifiedName(artist.name, verified: artist.verified),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Palette.muted),
                ),
              ],
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.green = false,
    this.outlined = false,
    this.width = 89,
  });
  final String label;
  final VoidCallback onTap;
  final bool green, outlined;
  final double width;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: outlined
              ? null
              : (green ? Palette.greenGradient : Palette.blueGradient),
          borderRadius: BorderRadius.circular(11),
          border: outlined ? Border.all(color: Palette.green, width: .7) : null,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}

class FollowButton extends StatelessWidget {
  const FollowButton(this.artist, {super.key});
  final Creative artist;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context),
        following = app.following.contains(artist.id);
    return GradientButton(
      label: following ? '✓ Following' : '+ Follow',
      outlined: following,
      onTap: () => app.toggleFollow(artist.id),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    required this.eyebrow,
    this.onTitleTap,
  });
  final String title, eyebrow;
  final VoidCallback? onTitleTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(fontSize: 13, color: Palette.muted),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTitleTap,
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -.7,
                  ),
                ),
              ),
            ),
            Avatar('me', onTap: () => openArtist(context, me)),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: .5),
      ],
    ),
  );
}

class ArtTile extends StatelessWidget {
  const ArtTile(this.art, {super.key, this.onTap});
  final Artwork art;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Open ${art.title}',
    button: true,
    child: GestureDetector(
      key: ValueKey('art-${art.id}'),
      onTap: onTap ?? () => openWork(context, art),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ArtImage(art.image),
            if (art.video || art.is3d)
              Positioned(
                left: 10,
                bottom: 10,
                child: Row(
                  children: [
                    if (art.video) const MediaBadge(CupertinoIcons.play_fill),
                    const SizedBox(width: 7),
                    MediaBadge(
                      art.is3d
                          ? CupertinoIcons.cube_fill
                          : CupertinoIcons.square_fill_on_square_fill,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class MediaBadge extends StatelessWidget {
  const MediaBadge(this.icon, {super.key});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    width: 25,
    height: 25,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0x88303A44),
    ),
    child: Icon(icon, size: 12),
  );
}

class ArtGrid extends StatelessWidget {
  const ArtGrid(this.works, {super.key, this.shrinkWrap = true});
  final List<Artwork> works;
  final bool shrinkWrap;
  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(20),
    shrinkWrap: shrinkWrap,
    physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
    itemCount: works.length,
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 250,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemBuilder: (_, i) => ArtTile(works[i]),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = CupertinoIcons.search,
  });
  final String title, message;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 25),
    child: Column(
      children: [
        Icon(icon, size: 38, color: Palette.blue),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Palette.muted),
        ),
      ],
    ),
  );
}

class MoreButton extends StatelessWidget {
  const MoreButton({super.key});
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: 'More options',
    color: const Color(0xFF4A5A67),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    icon: const Icon(CupertinoIcons.ellipsis, color: Palette.muted),
    onSelected: (v) => notice(context, switch (v) {
      'Report' => 'Report preview',
      'Mute' => 'Mute preview',
      _ => 'Content preference preview',
    }),
    itemBuilder: (_) => ['Mute', 'Not interested', 'Report']
        .map(
          (v) => PopupMenuItem(
            value: v,
            child: Text(v, style: const TextStyle(fontSize: 13)),
          ),
        )
        .toList(),
  );
}
