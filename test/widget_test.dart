import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infinite/app/app.dart';
import 'package:infinite/app/app_controller.dart';
import 'package:infinite/data/local_repository.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Local interactions survive controller recreation and comments stay scoped',
    () async {
      final repository = LocalRepository(await SharedPreferences.getInstance());
      final app = AppController(repository);
      app.toggleLike('abduction');
      app.toggleSave('spiderman');
      app.toggleFollow('frank');
      app.addComment('abduction', '  Wonderful lighting!  ');
      app.addComment('spiderman', '');
      app.sendMessage('  Let’s collaborate.  ');
      app.sendMessage('  ');
      await Future<void>.delayed(Duration.zero);
      final restored = AppController(repository);
      expect(restored.liked, {'abduction'});
      expect(restored.saved, {'spiderman'});
      expect(restored.following, {'frank'});
      expect(restored.comments['abduction'], ['Wonderful lighting!']);
      expect(restored.comments['spiderman'], isNull);
      expect(restored.messages, ['Let’s collaborate.']);
      app.dispose();
      restored.dispose();
    },
  );

  testWidgets('Feed filter changes modes and search has an empty state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final app = AppController(
      LocalRepository(await SharedPreferences.getInstance()),
    );
    await tester.pumpWidget(InfiniteApp(controller: app));
    await tester.pumpAndSettle();
    expect(find.text('New'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('feed-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('mode-recommended')));
    await tester.pumpAndSettle();
    expect(find.text('Recommended'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('nav-4')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('global-search')),
      'no-such-artwork',
    );
    await tester.pumpAndSettle();
    expect(find.text('No publishes found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
