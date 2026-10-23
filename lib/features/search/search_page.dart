import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final input = TextEditingController();
  String category = 'All';
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context), query = input.text.toLowerCase().trim();
    final works = {for (final art in allWorks) art.id: art}.values
        .where(
          (a) =>
              '${a.title} ${a.creator.name}'.toLowerCase().contains(query) &&
              (category != 'Saved' || app.saved.contains(a.id)),
        )
        .toList();
    final people = creatives
        .where((p) => '${p.name} ${p.role}'.toLowerCase().contains(query))
        .toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const PageHeader(
          title: 'Search',
          eyebrow: 'Find your next source of inspiration',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.search,
                  color: Palette.muted,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    key: const ValueKey('global-search'),
                    controller: input,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search publishes or creatives',
                    ),
                  ),
                ),
                if (query.isNotEmpty)
                  IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      input.clear();
                      setState(() {});
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: Palette.muted,
                      size: 19,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            children: ['All', 'Creatives', 'Saved']
                .map(
                  (label) => ChoiceChip(
                    key: ValueKey('search-$label'),
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    selected: category == label,
                    showCheckmark: false,
                    selectedColor: Palette.blueDark,
                    side: const BorderSide(color: Palette.line),
                    onSelected: (_) => setState(() => category = label),
                  ),
                )
                .toList(),
          ),
        ),
        if (category == 'Creatives') ...[
          if (people.isEmpty)
            const EmptyState(
              title: 'No creatives found',
              message: 'Try another name or discipline.',
            ),
          ...people.map(
            (p) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: ArtistRow(p, subtitle: p.role, trailing: FollowButton(p)),
            ),
          ),
        ] else if (works.isEmpty)
          EmptyState(
            title: category == 'Saved'
                ? (query.isEmpty
                      ? 'Keep what inspires you'
                      : 'No saved publishes found')
                : 'No publishes found',
            message: category == 'Saved'
                ? (query.isEmpty
                      ? 'Save a publish from its detail page to find it here.'
                      : 'Clear your search to see the rest of your collection.')
                : 'Try a different title or creative name.',
          )
        else
          ArtGrid(works),
      ],
    );
  }
}
