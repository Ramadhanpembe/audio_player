import 'package:audio_player/screens/playlist_screen.dart';
import 'package:audio_player/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../customs/custom_search_delegate.dart';
import 'track_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.indigo,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          title: const Text('Audio Player'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Tracks',
              ),
              Tab(
                text: 'Playlists',
              ),
              Tab(
                text: 'Favorite',
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
            ),
            PopupMenuButton(
              padding: const EdgeInsets.all(8),
              icon: const Icon(Icons.more_vert),
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
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              TrackScreen(),
              PlaylistScreen(),
              Center(
                child: Text('This is Favorite screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
