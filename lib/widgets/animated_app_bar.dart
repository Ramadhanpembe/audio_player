import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/settings_screen.dart';
import '../utils/constants.dart';

class AnimatedAppBar extends StatelessWidget {
  const AnimatedAppBar({
    super.key,
    required this.title,
    required this.opacity,
  });

  final String title;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Text(
          title,
          style: kAppTitle.copyWith(
            color: const Color(kPrimaryColor),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 45,
      elevation: 0,
      actions: [
        IconButton(
          padding: const EdgeInsets.all(8),
          splashColor: const Color(kSplashColor),
          icon: const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: Color(kPrimaryColor),
          ),
          onPressed: () {},
        ),
        PopupMenuButton(
          padding: const EdgeInsets.all(8),
          icon: const FaIcon(
            FontAwesomeIcons.ellipsisVertical,
            color: Color(kPrimaryColor),
          ),
          onSelected: (value) {
            if (value == 'settings') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            }
          },
          onOpened: () {},
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                // in this same field, if all are expanded, then it should change to Collapse All
                child: Text('Expand All'),
              ),
              const PopupMenuItem(
                child: Text('Delete Multiple'),
              ),
              const PopupMenuItem(
                child: Text('Delete All'),
              ),
            ];
          },
        ),
      ],
    );
  }
}
