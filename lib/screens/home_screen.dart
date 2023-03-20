import 'package:audio_player/screens/favorite_screen.dart';
import 'package:audio_player/screens/playlist_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';

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
          systemOverlayStyle: kSystemUiOverlayStyle,
          title: const Text('Audio Player'),
          bottom: _buildTabBar(),
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
            _buildPopupMenuButton(),
          ],
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              TrackScreen(),
              PlaylistScreen(),
              FavoriteScreen(),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> _buildPopupMenuButton() {
    return PopupMenuButton(
      padding: const EdgeInsets.all(8),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {},
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
    );
  }

  TabBar _buildTabBar() {
    return const TabBar(
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
    );
  }
}
