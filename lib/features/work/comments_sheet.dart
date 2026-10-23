import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';

void showComments(BuildContext context, Artwork art) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsSheet(art: art),
    );

class CommentsSheet extends StatefulWidget {
  const CommentsSheet({super.key, required this.art});
  final Artwork art;
  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final input = TextEditingController();
  bool newest = false;
  final Set<int> liked = {}, replies = {};
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context),
        comments = app.comments[widget.art.id] ?? [];
    void send() {
      if (input.text.trim().isEmpty) return;
      app.addComment(widget.art.id, input.text);
      input.clear();
      FocusScope.of(context).unfocus();
      setState(() => newest = true);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        height: MediaQuery.sizeOf(context).height * .65,
        decoration: const BoxDecoration(
          color: Palette.panel,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 13, 10, 13),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Comments: ${14 + comments.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Palette.muted,
                        ),
                      ),
                    ),
                    for (final value in [false, true])
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => newest = value),
                          child: Container(
                            width: 68,
                            height: 29,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: newest == value
                                    ? Palette.blue
                                    : Palette.line,
                              ),
                              color: Colors.black12,
                            ),
                            child: Text(
                              value ? 'New' : 'Popular',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                    IconButton(
                      key: const ValueKey('close-comments'),
                      tooltip: 'Close comments',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(CupertinoIcons.xmark, size: 15),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (newest) ...comments.reversed.map(_ownComment),
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ArtistRow(
                              Creative(
                                'comment-$i',
                                [
                                  'Ashleigh Warner',
                                  'Lars Sowig',
                                  'Colin Volrath',
                                ][i],
                                'Artist',
                                ['ashleigh', 'lars', 'colin'][i],
                              ),
                              trailing: const MoreButton(),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Really nice! Well done!',
                              style: TextStyle(fontSize: 12),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    input.text =
                                        '@${['Ashleigh', 'Lars', 'Colin'][i]} ';
                                    setState(() {});
                                  },
                                  child: const Text(
                                    '↶ Reply',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Palette.muted,
                                    ),
                                  ),
                                ),
                                if (i == 1)
                                  TextButton(
                                    onPressed: () => setState(
                                      () => replies.contains(i)
                                          ? replies.remove(i)
                                          : replies.add(i),
                                    ),
                                    child: Text(
                                      replies.contains(i)
                                          ? 'Hide replies'
                                          : '3 Replies⌄',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                const Spacer(),
                                Text(
                                  '${[5, 0, 1][i] + (liked.contains(i) ? 1 : 0)}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                IconButton(
                                  tooltip: 'Like comment',
                                  onPressed: () => setState(
                                    () => liked.contains(i)
                                        ? liked.remove(i)
                                        : liked.add(i),
                                  ),
                                  icon: Icon(
                                    CupertinoIcons.bolt_fill,
                                    size: 17,
                                    color: liked.contains(i)
                                        ? Palette.blue
                                        : Palette.muted,
                                  ),
                                ),
                              ],
                            ),
                            if (replies.contains(i))
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 16),
                                child: Text(
                                  'Frank Marshall  •  Thank you so much!\nAshleigh  •  Love the lighting.\nColin  •  Same here!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Palette.muted,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                    if (!newest) ...comments.map(_ownComment),
                  ],
                ),
              ),
              Container(
                color: Colors.black12,
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('comment-input'),
                        controller: input,
                        maxLength: 500,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => send(),
                        decoration: const InputDecoration(
                          hintText: 'Tap to write a comment...',
                          counterText: '',
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('send-comment'),
                      tooltip: 'Send comment',
                      onPressed: send,
                      icon: const Icon(
                        CupertinoIcons.paperplane_fill,
                        color: Palette.blue,
                        size: 25,
                      ),
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

  Widget _ownComment(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ArtistRow(me, subtitle: 'Just now'),
        const SizedBox(height: 12),
        Text(text, style: const TextStyle(fontSize: 12)),
        const Divider(height: 24),
      ],
    ),
  );
}
