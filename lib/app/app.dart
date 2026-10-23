import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/content.dart';
import '../features/profile/profile_page.dart';
import '../features/work/work_page.dart';
import '../features/messaging/chat_page.dart';
import '../core/app_navigation.dart';
import '../core/widgets.dart';
import '../features/feed/feed_page.dart';
import '../features/feed/filter_sheet.dart';
import '../features/explore/explore_page.dart';
import '../features/messaging/inbox_page.dart';
import '../features/search/search_page.dart';
import 'app_controller.dart';
import 'app_scope.dart';

class InfiniteApp extends StatelessWidget {
  const InfiniteApp({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => AppScope(
    controller: controller,
    child: MaterialApp(
      title: 'Infinite',
      debugShowCheckedModeBanner: false,
      theme: Palette.theme,
      home: const AppShell(),
      onGenerateRoute: (settings) => switch (settings.name) {
        '/artist' => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ProfilePage(artist: settings.arguments! as Creative),
        ),
        '/work' => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => WorkPage(art: settings.arguments! as Artwork),
        ),
        '/chat' => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ChatPage(),
        ),
        _ => null,
      },
    ),
  );
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: switch (app.tab) {
                  0 => const FeedPage(),
                  1 => const ExplorePage(),
                  2 => const ActivityPage(),
                  3 => const InboxPage(),
                  _ => const SearchPage(),
                },
              ),
              AppNavigation(
                selected: app.tab,
                onSelect: (i) {
                  if (i == 0 && app.tab == 0) {
                    showFeedFilter(context);
                  } else {
                    app.selectTab(i);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
