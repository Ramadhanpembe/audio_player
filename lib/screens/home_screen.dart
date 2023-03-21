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
            IconButton(
              icon: const Icon(Icons.dehaze_outlined),
              onPressed: () {},
            )
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

  TabBar _buildTabBar() {
    return const TabBar(
      tabs: [
        Tab(
          text: 'TRACKS',
        ),
        Tab(
          text: 'PLAYLISTS',
        ),
        Tab(
          text: 'FAVORITES',
        ),
      ],
    );
  }
}
