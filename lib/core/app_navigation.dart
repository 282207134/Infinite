import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({
    super.key,
    required this.selected,
    required this.onSelect,
  });
  final int selected;
  final ValueChanged<int> onSelect;
  static const labels = ['Feed', 'Explore', 'Notifications', 'Inbox', 'Search'];
  static const icons = [
    CupertinoIcons.doc_richtext,
    CupertinoIcons.square_stack_3d_up_fill,
    CupertinoIcons.bell_fill,
    CupertinoIcons.tray_fill,
    CupertinoIcons.search,
  ];
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Color(0xFF4A5A67),
      border: Border(top: BorderSide(color: Palette.line, width: .5)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 55,
        child: Row(
          children: List.generate(
            5,
            (i) => Expanded(
              child: InkWell(
                key: ValueKey('nav-$i'),
                onTap: () => onSelect(i),
                child: Semantics(
                  selected: selected == i,
                  button: true,
                  label: labels[i],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[i],
                        size: 24,
                        color: i == 3
                            ? Palette.gold
                            : selected == i
                            ? Colors.white
                            : Palette.muted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 10,
                          color: selected == i ? Colors.white : Palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
