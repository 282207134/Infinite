import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/app_navigation.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.artist = me});
  final Creative artist;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context), person = widget.artist;
    final works = tab == 0
        ? profileWorks
        : allWorks.where((a) => app.liked.contains(a.id)).toSet().toList();
    return Scaffold(
      bottomNavigationBar: AppNavigation(
        selected: app.tab,
        onSelect: (i) {
          app.selectTab(i);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 105,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: .13,
                        child: const ArtImage('profile_cover'),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 19,
                      child: IconButton(
                        key: const ValueKey('back'),
                        tooltip: 'Back',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          CupertinoIcons.chevron_left,
                          color: Palette.muted,
                        ),
                      ),
                    ),
                    Positioned(right: 9, top: 19, child: const MoreButton()),
                    Align(
                      alignment: Alignment.center,
                      child: Avatar(person.avatar, size: 60),
                    ),
                  ],
                ),
              ),
              Center(
                child: VerifiedName(person.name, verified: person.verified),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  person.role,
                  style: const TextStyle(fontSize: 11, color: Palette.muted),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tag(
                    CupertinoIcons.location_solid,
                    'Paris, France',
                    Palette.orange,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        const ClipboardData(text: 'https://ui8.net'),
                      );
                      notice(context, 'Website address copied.');
                    },
                    child: _tag(
                      CupertinoIcons.link,
                      'ui8.thefagnum.net',
                      Palette.blueDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FollowButton(person),
                  const SizedBox(width: 20),
                  GradientButton(
                    key: const ValueKey('profile-message'),
                    label: 'Message',
                    green: true,
                    onTap: () => openChat(context),
                  ),
                ],
              ),
              const SizedBox(height: 42),
              Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      child: InkWell(
                        key: ValueKey('profile-tab-$i'),
                        onTap: () => setState(() => tab = i),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: tab == i ? Palette.blue : Palette.line,
                                width: tab == i ? 3 : .5,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                ['Works', 'Likes', 'Following'][i],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: tab == i
                                      ? Palette.blue
                                      : Palette.muted,
                                ),
                              ),
                              Text(
                                [
                                  '137',
                                  '${2085 + app.liked.length}',
                                  '${269 + app.following.length}',
                                ][i],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: tab == i
                                      ? Colors.white
                                      : Palette.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (tab == 2) ...[
                if (app.following.isEmpty)
                  const EmptyState(
                    title: 'Find your people',
                    message: 'Follow creatives to build your own circle.',
                    icon: CupertinoIcons.person_2,
                  ),
                ...creatives
                    .where((p) => app.following.contains(p.id))
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: ArtistRow(
                          p,
                          subtitle: p.role,
                          trailing: FollowButton(p),
                        ),
                      ),
                    ),
              ] else if (works.isEmpty)
                const EmptyState(
                  title: 'Your inspiration starts here',
                  message: 'Like a publish to see it in this collection.',
                  icon: CupertinoIcons.heart,
                )
              else
                ArtGrid(works),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(IconData icon, String text, Color color) => Container(
    padding: const EdgeInsets.fromLTRB(3, 3, 10, 3),
    decoration: BoxDecoration(
      color: Colors.black26,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: color,
          child: Icon(icon, size: 12, color: Colors.white),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 11)),
      ],
    ),
  );
}
