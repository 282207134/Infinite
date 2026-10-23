import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';
import 'comments_sheet.dart';

class WorkActions extends StatelessWidget {
  const WorkActions({super.key, required this.art, this.showViews = false});
  final Artwork art;
  final bool showViews;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context), liked = app.liked.contains(art.id);
    return Row(
      children: [
        _pill(
          'like-work',
          CupertinoIcons.bolt_fill,
          '${1593 + (liked ? 1 : 0)}',
          liked,
          () => app.toggleLike(art.id),
        ),
        const SizedBox(width: 12),
        _pill(
          'comments-work',
          CupertinoIcons.chat_bubble_text_fill,
          '${206 + (app.comments[art.id]?.length ?? 0)}',
          false,
          () => showComments(context, art),
        ),
        const SizedBox(width: 12),
        _pill(
          'share-work',
          CupertinoIcons.arrowshape_turn_up_right_fill,
          '',
          false,
          () async {
            await Clipboard.setData(
              ClipboardData(
                text: 'Infinite • ${art.title} by ${art.creator.name}',
              ),
            );
            if (context.mounted) {
              notice(context, 'Publish details copied to clipboard.');
            }
          },
        ),
        if (showViews) ...[
          const Spacer(),
          const Text(
            '▥ 8K',
            style: TextStyle(fontSize: 11, color: Palette.muted),
          ),
        ],
      ],
    );
  }

  Widget _pill(
    String id,
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) => Semantics(
    button: true,
    label: id,
    selected: active,
    child: GestureDetector(
      key: ValueKey(id),
      onTap: onTap,
      child: Container(
        height: 29,
        constraints: BoxConstraints(minWidth: label.isEmpty ? 55 : 68),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          gradient: active ? Palette.blueGradient : null,
          color: active ? null : Colors.black26,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
