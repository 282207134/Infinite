import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_controller.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';
import '../profile/profile_page.dart';

void showFeedFilter(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  barrierColor: Colors.black26,
  builder: (_) => const FilterSheet(),
);

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late final query = TextEditingController(
    text: AppScope.of(context).creatorQuery,
  );
  String? expanded = 'greg';
  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context), searching = query.text.isNotEmpty;
    final people = creatives
        .where(
          (p) => '${p.name} ${p.role}'.toLowerCase().contains(
            query.text.toLowerCase(),
          ),
        )
        .toList();
    return SizedBox(
      height:
          MediaQuery.sizeOf(context).height * .65 +
          MediaQuery.viewInsetsOf(context).bottom,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Palette.panel.withValues(alpha: .92),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  children: [
                    Center(
                      child: Container(
                        width: 120,
                        height: 27,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            for (final grid in [true, false])
                              Expanded(
                                child: GestureDetector(
                                  key: ValueKey(
                                    grid ? 'view-grid' : 'view-list',
                                  ),
                                  onTap: () => app.setGrid(grid),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: app.grid == grid
                                          ? const Color(0xFF748FA5)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      grid
                                          ? CupertinoIcons.square_grid_2x2_fill
                                          : CupertinoIcons.list_bullet,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    if (!searching) ...[
                      for (final mode in FeedMode.values)
                        InkWell(
                          key: ValueKey('mode-${mode.name}'),
                          onTap: () {
                            app.selectFeed(mode);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    mode.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: app.feedMode == mode
                                          ? Colors.white
                                          : Palette.muted,
                                    ),
                                  ),
                                ),
                                if (app.feedMode == mode)
                                  const Icon(
                                    CupertinoIcons.bolt_circle_fill,
                                    color: Palette.orange,
                                    size: 22,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                    ],
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.search,
                          size: 19,
                          color: Palette.muted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            key: const ValueKey('creator-search'),
                            controller: query,
                            onChanged: (v) {
                              app.creatorQuery = v;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Following: 184 • 19',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                            ),
                          ),
                        ),
                        if (searching)
                          IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              query.clear();
                              app.creatorQuery = '';
                              setState(() {});
                            },
                            icon: const Icon(CupertinoIcons.xmark, size: 17),
                          ),
                      ],
                    ),
                    const Divider(height: 1),
                    if (people.isEmpty)
                      const EmptyState(
                        title: 'No creatives found',
                        message: 'Try a name or a creative discipline.',
                      ),
                    ...people.map(
                      (person) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ArtistRow(
                              person,
                              subtitle: person.role,
                              trailing: IconButton(
                                tooltip: 'Artist actions',
                                onPressed: () => setState(
                                  () => expanded = expanded == person.id
                                      ? null
                                      : person.id,
                                ),
                                icon: Icon(
                                  expanded == person.id
                                      ? CupertinoIcons.chevron_up
                                      : CupertinoIcons.chevron_down,
                                  color: Palette.muted,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          if (expanded == person.id)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  _action('Profile', () {
                                    Navigator.pop(context);
                                    pushPage(
                                      context,
                                      ProfilePage(artist: person),
                                    );
                                  }),
                                  const SizedBox(width: 1),
                                  _action('Send to', () {
                                    Navigator.pop(context);
                                    openChat(context);
                                  }),
                                  const SizedBox(width: 1),
                                  _action(
                                    app.following.contains(person.id)
                                        ? 'Unfollow'
                                        : 'Follow',
                                    () => app.toggleFollow(person.id),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _action(String label, VoidCallback onTap) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, color: Palette.muted),
        ),
      ),
    ),
  );
}
