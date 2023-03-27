import 'package:audio_player/screens/favorite_screen.dart';
import 'package:audio_player/screens/playlist_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/hanging_player_control.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../customs/custom_search_delegate.dart';
import '../logics/player_query_resources.dart';
import '../main.dart';
import 'track_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          _tabIndex = _tabController.index;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultTabController(context);
  }

  Scaffold _buildDefaultTabController(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: kSystemUiOverlayStyle,
        title: const Text(
          'Play',
          style: TextStyle(fontSize: 24.0),
        ),
        bottom: _buildTabBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _showCustomSearchDelegate(_tabIndex),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.dehaze_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: isBackArrowClickedNotifier,
          builder: (_, isClicked, __) {
            if (isClicked) {
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  _buildTabBarView(),
                  const HangingPlayerControl(),
                ],
              );
            }
            return _buildTabBarView();
          },
        ),
      ),
    );
  }

  CustomSearchDelegate _showCustomSearchDelegate(int tabIndex) {
    if (_tabIndex == 0) {
      return CustomSearchDelegate(list: tracks, tabIndex: _tabIndex);
    } else if (_tabIndex == 2) {
      return CustomSearchDelegate(list: addedFavorites, tabIndex: _tabIndex);
    } else {
      return CustomSearchDelegate(list: playlists, tabIndex: _tabIndex);
    }
  }

  TabBarView _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        const TrackScreen(),
        const PlaylistScreen(),
        FavoriteScreen(
          onRemoveToFavorite: (BuildContext context, SongModel track) {
            queryManager.removeFromFavorite(track);
            Navigator.pop(context);
            favoritesEntities = queryManager.initFavorites;
            setState(() {});
          },
        ),
      ],
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.white,
      indicatorWeight: 1.5,
      labelColor: Colors.white,
      tabs: const [
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
