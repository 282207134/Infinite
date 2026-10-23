import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/content.dart';
import '../profile/profile_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final input = TextEditingController(), scroll = ScrollController();
  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    void send() {
      if (input.text.trim().isEmpty) return;
      app.sendMessage(input.text);
      input.clear();
      FocusScope.of(context).unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scroll.hasClients) {
          scroll.animateTo(
            scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 12, 10, 18),
                child: Row(
                  children: [
                    IconButton(
                      key: const ValueKey('back'),
                      tooltip: 'Back',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        CupertinoIcons.chevron_left,
                        color: Palette.muted,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Expanded(child: ArtistRow(mary, subtitle: 'HR')),
                    const MoreButton(),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 13,
                        ),
                        decoration: BoxDecoration(
                          gradient: Palette.blueGradient,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          'December 24',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _bubble(
                      const Text(
                        'Hi, Peter! I’m Mary from The Daily Bugle. We have a creative concept task. Would it be interesting to you? If yes here is the work agreement.',
                        style: TextStyle(fontSize: 12, height: 1.65),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Marvel_agreement.pdf'),
                            content: const Text(
                              'Reference attachment from the Pixso conversation. No PDF file was included in the design.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: Palette.orange,
                                child: Icon(
                                  CupertinoIcons.doc_fill,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Marvel_agreement.pdf',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _bubble(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hi, MJ! Sorry I’m busy on some INSOMNIAC projects right now. But I can advise my friend - Miles.',
                            style: TextStyle(fontSize: 12, height: 1.65),
                          ),
                          const SizedBox(height: 12),
                          ArtistRow(
                            miles,
                            subtitle: miles.role,
                            onTap: () => pushPage(
                              context,
                              const ProfilePage(artist: miles),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const SizedBox(
                            height: 90,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    child: ArtImage('miles1', height: 90),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    child: ArtImage('miles2', height: 90),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      outgoing: true,
                    ),
                    _bubble(
                      const Text(
                        'Thanks a lot. Catch you soon, Tiger!',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    ...app.messages.map(
                      (text) => _bubble(
                        Text(
                          text,
                          style: const TextStyle(fontSize: 12, height: 1.5),
                        ),
                        outgoing: true,
                        now: true,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2D3941),
                  border: Border(top: BorderSide(color: Palette.line)),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Attach a file',
                      onPressed: () => notice(
                        context,
                        'File upload becomes available when a messaging service is connected.',
                      ),
                      icon: const Icon(
                        CupertinoIcons.paperclip,
                        color: Palette.muted,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        key: const ValueKey('chat-input'),
                        controller: input,
                        maxLines: 3,
                        minLines: 1,
                        maxLength: 1000,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => send(),
                        decoration: const InputDecoration(
                          hintText: 'Seems like great responsibility',
                          counterText: '',
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('send-message'),
                      tooltip: 'Send message',
                      onPressed: send,
                      icon: const Icon(
                        CupertinoIcons.paperplane_fill,
                        color: Palette.blue,
                        size: 26,
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

  Widget _bubble(Widget child, {bool outgoing = false, bool now = false}) =>
      Align(
        alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: outgoing ? 284 : null,
          constraints: const BoxConstraints(maxWidth: 284),
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          decoration: BoxDecoration(
            color: outgoing ? const Color(0xFF4A5A67) : Colors.black26,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  now
                      ? 'Just now ✓✓'
                      : outgoing
                      ? '09:41 ✓✓'
                      : '09:41',
                  style: const TextStyle(fontSize: 10, color: Palette.muted),
                ),
              ),
            ],
          ),
        ),
      );
}
