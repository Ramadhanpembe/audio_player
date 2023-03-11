import 'package:audio_player/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../customs/custom_search_delegate.dart';
import '../models/call_info.dart';
import '../utils/constants.dart';
import '../utils/sample_data.dart';
import '../widgets/collapsed_recording_tile.dart';
import '../widgets/empty_container.dart';
import '../widgets/expanded_recording_tile.dart';
import 'library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CallInfo> _list = list;
  bool _isClicked = false;

  /// Sets a dynamic expandedHeight of the AppBar when there are less than two recording tiles.
  /// If the number of recording tiles exceeds two, the default expandedHeight of the AppBar will be returned.
  double get _expandedHeight {
    double screenHeight = MediaQuery.of(context).size.height;
    return _list.length <= 2 ? 2 / 3 * screenHeight : kAppBarExpandedHeight;
  }

  /// Sets the dynamic padding of the content or text displayed by the EmptyContainer when there are no recording tiles yet.
  double get _padding {
    double height = MediaQuery.of(context).size.height - _expandedHeight;
    if (_expandedHeight != kAppBarExpandedHeight) {
      return height * 0.35;
    }
    return 0;
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
                text: 'Library',
              ),
              Tab(
                text: 'Directory',
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
        body: SafeArea(
          child: TabBarView(
            children: [
              const LibraryScreen(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child:

                    /// Checks whether the recording list is empty or not.
                    /// If its not empty, the SliverList is returned, else the EmptyContainer will be returned.
                    _list.isNotEmpty
                        ? ListView.builder(
                            itemCount: _list.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Theme(
                                  data: ThemeData(
                                    splashColor: _list[index].isExpanded
                                        ? Colors.transparent
                                        : const Color(kSplashColor),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: ExpansionPanelList(
                                    dividerColor: Colors.transparent,
                                    expandedHeaderPadding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    elevation: 0.0,
                                    expansionCallback: (indexNo, isOpen) {
                                      setState(() {
                                        /// Equates the the ScrollView recording index to the PanelList index.
                                        /// Sets the state of the recording tile to opposite of its current state when it is clicked.
                                        indexNo = index;
                                        _list[indexNo].isExpanded = !isOpen;
                                        _isClicked = true;
                                      });
                                    },
                                    children: [
                                      ExpansionPanel(
                                        hasIcon: false,
                                        canTapOnHeader: true,
                                        isExpanded: _list[index].isExpanded,
                                        headerBuilder: (context, isExpanded) {
                                          return CollapsedRecordingTile(
                                            isClicked: _isClicked,
                                            isExpanded: _list[index].isExpanded,
                                            phone: _list[index].phone,
                                            caller: _list[index].caller,
                                            duration: _list[index].duration,
                                            datetime: _list[index].datetime,
                                          );
                                        },
                                        body: ExpandedRecordingTile(
                                          isExpanded: _list[index].isExpanded,
                                          sliderValue: 2,
                                          timeElapsed: '1:05',
                                          timeRemained: '-8:15',
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          )
                        : EmptyContainer(
                            padding: _padding,
                          ),
              ),
              const Center(
                child: Text('This is Favorite screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
