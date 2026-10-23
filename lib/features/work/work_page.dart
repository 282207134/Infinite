import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';
import '../../core/art_gallery.dart';
import 'work_actions.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key, required this.art, this.startVideo = false});
  final Artwork art;
  final bool startVideo;
  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  late final List<Artwork> works;
  late final PageController pages;
  late int index;
  bool details = false, playing = false, video = false;
  double position = 68;
  Timer? timer;
  Artwork get art => works[index];
  @override
  void initState() {
    super.initState();
    works = gallery.any((a) => a.id == widget.art.id)
        ? gallery
        : [widget.art, ...gallery.take(6)];
    index = works.indexWhere((a) => a.id == widget.art.id);
    pages = PageController(initialPage: index);
    video = widget.startVideo;
    if (video) _togglePlayback();
  }

  void _togglePlayback() {
    setState(() {
      video = true;
      playing = !playing;
    });
    timer?.cancel();
    if (playing) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          position = (position + 1).clamp(0, 179);
          if (position >= 179) {
            playing = false;
            timer?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    pages.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      backgroundColor: Palette.bottom,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              key: const ValueKey('work-gallery'),
              controller: pages,
              itemCount: works.length,
              onPageChanged: (i) {
                timer?.cancel();
                setState(() {
                  index = i;
                  playing = false;
                  video = false;
                });
              },
              itemBuilder: (_, i) => Stack(
                fit: StackFit.expand,
                children: [
                  ArtImage(works[i].image),
                  Container(color: Colors.black.withValues(alpha: .25)),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: details ? 245 : 65),
                      child: ArtImage(
                        works[i].image,
                        width: double.infinity,
                        fit: works[i].id == 'abduction'
                            ? BoxFit.fitWidth
                            : BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 150,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SizedBox(
              height: 55,
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey('back'),
                    tooltip: 'Back',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(CupertinoIcons.chevron_left, size: 20),
                  ),
                  const Text('▥ 89 032', style: TextStyle(fontSize: 11)),
                  const Spacer(),
                  Container(
                    width: 105,
                    height: 32,
                    decoration: const BoxDecoration(
                      gradient: Palette.blueGradient,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(17),
                        bottomLeft: Radius.circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('${index + 1}'),
                        Container(width: 4, height: 32, color: Palette.bottom),
                        Text('${works.length}'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const MoreButton(),
                ],
              ),
            ),
          ),
          if (video)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _VideoControl(
                  playing: playing,
                  position: position,
                  onPlay: _togglePlayback,
                  onSeek: (v) => setState(() => position = v),
                ),
              ),
            ),
          if (!video && art.video)
            Positioned(
              right: 20,
              top: MediaQuery.sizeOf(context).height * .42,
              child: IconButton.filledTonal(
                key: const ValueKey('play-video'),
                tooltip: 'Play motion preview',
                style: IconButton.styleFrom(backgroundColor: Colors.black38),
                onPressed: _togglePlayback,
                icon: const Icon(CupertinoIcons.play_fill, size: 24),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              key: const ValueKey('work-panel'),
              decoration: BoxDecoration(
                color: Palette.panel.withValues(alpha: .97),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      key: const ValueKey('work-details'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => details = !details),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ArtistRow(
                              art.creator,
                              trailing: FollowButton(art.creator),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    art.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  details
                                      ? CupertinoIcons.chevron_down
                                      : CupertinoIcons.chevron_up,
                                  size: 15,
                                  color: Palette.muted,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (details)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.sizeOf(context).height * .32,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  8,
                                ),
                                child: Text(
                                  art.id == 'spiderman'
                                      ? workDescription
                                      : 'A study in light, movement and storytelling. Exploring a new world through concept art, from the first sketch to the final scene.',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFCFD9E4),
                                    height: 1.7,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 6, 20, 14),
                                child: Text(
                                  'More by Frank Marshall',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Palette.blue,
                                  ),
                                ),
                              ),
                              const MiniGallery(
                                images: ['more1', 'more2', 'more3'],
                              ),
                              const SizedBox(height: 14),
                            ],
                          ),
                        ),
                      ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: WorkActions(art: art)),
                          const SizedBox(width: 12),
                          IconButton(
                            key: const ValueKey('save-work'),
                            tooltip: app.saved.contains(art.id)
                                ? 'Remove from collection'
                                : 'Save to collection',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 38,
                              minHeight: 30,
                            ),
                            onPressed: () => app.toggleSave(art.id),
                            icon: Icon(
                              app.saved.contains(art.id)
                                  ? CupertinoIcons.bookmark_fill
                                  : CupertinoIcons.bookmark,
                              color: app.saved.contains(art.id)
                                  ? Palette.gold
                                  : Palette.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoControl extends StatelessWidget {
  const _VideoControl({
    required this.playing,
    required this.position,
    required this.onPlay,
    required this.onSeek,
  });
  final bool playing;
  final double position;
  final VoidCallback onPlay;
  final ValueChanged<double> onSeek;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 230,
    height: 270,
    child: Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: _ProgressRing(position / 179),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: const ValueKey('toggle-playback'),
                  tooltip: playing ? 'Pause preview' : 'Resume preview',
                  iconSize: 58,
                  onPressed: onPlay,
                  icon: Icon(
                    playing
                        ? CupertinoIcons.pause_fill
                        : CupertinoIcons.play_fill,
                  ),
                ),
                Text(
                  '${position ~/ 60}:${(position.toInt() % 60).toString().padLeft(2, '0')} / 02:59',
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Motion preview',
                  style: TextStyle(fontSize: 10, color: Palette.muted),
                ),
              ],
            ),
          ),
        ),
        Slider(value: position, max: 179, onChanged: onSeek),
      ],
    ),
  );
}

class _ProgressRing extends CustomPainter {
  _ProgressRing(this.value);
  final double value;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawArc(
      rect.deflate(4),
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..color = Palette.blue
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
    canvas.drawArc(
      rect.deflate(4),
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      Paint()
        ..color = Palette.orange
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_ProgressRing oldDelegate) => value != oldDelegate.value;
}
