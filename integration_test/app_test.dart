import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infinite/main.dart' as app;
import 'package:infinite/core/widgets.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;
  testWidgets('Pixso screens and complete local interaction journey', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('infinite.state.v1');
    await app.main();
    await tester.pumpAndSettle();
    Future<void> tap(String key) async {
      await tester.tap(find.byKey(ValueKey(key)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'After tapping $key');
    }

    Future<void> shot(String name) async {
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await binding.takeScreenshot(name);
    }

    await shot('01-feed-new');
    await tap('feed-filter');
    await shot('04-feed-filter');
    await tester.enterText(
      find.byKey(const ValueKey('creator-search')),
      'James Ko',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await shot('05-filter-search');
    expect(find.text('James Kong'), findsOneWidget);
    expect(find.text('Frank Marshall'), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('creator-search')), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tap('view-list');
    await tap('mode-fresh');
    await shot('16-feed-list');
    await tap('feed-filter');
    await tap('view-grid');
    await tap('mode-recommended');
    await shot('02-feed-recommended');
    await tester.tap(find.text('+ Follow').first);
    await tester.pumpAndSettle();
    expect(find.text('✓ Following'), findsOneWidget);
    await tap('recommended-work');
    await tap('like-work');
    expect(find.text('1594'), findsOneWidget);
    await tap('save-work');
    expect(find.byTooltip('Remove from collection'), findsOneWidget);
    await shot('09-work');
    await tester.drag(
      find.byKey(const ValueKey('work-gallery')),
      const Offset(-320, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Marvel’s Spider-Man'), findsOneWidget);
    await tap('work-details');
    expect(find.textContaining("I'm really excited"), findsOneWidget);
    await shot('10-work-description');
    await tap('comments-work');
    await shot('11-comments');
    await tester.enterText(
      find.byKey(const ValueKey('comment-input')),
      'Wonderful lighting!',
    );
    await tap('send-comment');
    expect(find.text('Wonderful lighting!'), findsOneWidget);
    await shot('18-comment-sent');
    await tap('close-comments');
    await tap('work-details');
    await tap('play-video');
    await shot('12-video');
    await tap('toggle-playback');
    await tap('back');
    await tap('nav-0');
    await tap('mode-activity');
    await shot('03-feed-activity');
    await tap('nav-1');
    await shot('06-explore');
    await tester.tap(find.byType(MoreButton).first);
    await tester.pumpAndSettle();
    await shot('17-explore-menu');
    await tester.tapAt(const Offset(20, 180));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Avatar).first);
    await tester.pumpAndSettle();
    expect(find.text('Ruslan Sakhbetdinov'), findsOneWidget);
    await shot('07-profile');
    await tap('profile-message');
    await shot('08-chat');
    await tester.enterText(
      find.byKey(const ValueKey('chat-input')),
      'Let’s create something great.',
    );
    await tap('send-message');
    await tester.pumpAndSettle();
    expect(find.text('Let’s create something great.'), findsOneWidget);
    await shot('19-chat-sent');
    await tap('back');
    await tap('back');
    await tap('nav-3');
    await shot('13-inbox');
    await tap('nav-4');
    await shot('14-search');
    await tester.enterText(
      find.byKey(const ValueKey('global-search')),
      'Spider',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await shot('15-search-results');
    expect(find.byKey(const ValueKey('art-spiderman')), findsOneWidget);
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('global-search')))
          .controller!
          .text,
      isEmpty,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tap('search-Saved');
    await shot('20-saved');
    expect(find.byKey(const ValueKey('art-abduction')), findsOneWidget);
    expect(tester.takeException(), isNull);
    final state = prefs.getString('infinite.state.v1')!;
    expect(state, contains('Wonderful lighting!'));
    expect(state, contains('Let’s create something great.'));
  });
}
