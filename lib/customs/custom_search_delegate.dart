import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/call_info.dart';
import '../utils/sample_data.dart';
import '../widgets/collapsed_recording_tile.dart';
import '../widgets/expanded_recording_tile.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<CallInfo> _list = list;

  @override
  String get searchFieldLabel => 'Search...';

  @override
  TextStyle get searchFieldStyle {
    return const TextStyle(
      color: Colors.white,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent,
      decorationThickness: 0,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<CallInfo> results = [];
    for (var call in _list) {
      if (call.caller!.toLowerCase().contains(query.toLowerCase())) {
        results.add(call);
      }
    }
    return ListView.builder(
      itemCount: results.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ExpansionPanelList(
          dividerColor: Colors.transparent,
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
          elevation: 0.0,
          expansionCallback: (indexNo, isOpen) {
            /// Equates the the ScrollView recording index to the PanelList index.
            /// Sets the state of the recording tile to opposite of its current state when it is clicked.
            indexNo = index;
            _list[indexNo].isExpanded = !isOpen;
          },
          children: [
            ExpansionPanel(
              hasIcon: false,
              canTapOnHeader: true,
              isExpanded: _list[index].isExpanded,
              headerBuilder: (context, isExpanded) {
                return CollapsedRecordingTile(
                  isClicked: false,
                  isExpanded: results[index].isExpanded,
                  phone: results[index].phone,
                  caller: results[index].caller,
                  duration: results[index].duration,
                  datetime: results[index].datetime,
                );
              },
              body: ExpandedRecordingTile(
                isExpanded: results[index].isExpanded,
                sliderValue: 2,
                timeElapsed: '1:05',
                timeRemained: '-8:15',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<CallInfo> results = [];
    for (var call in _list) {
      if (call.caller!.toLowerCase().contains(query.toLowerCase())) {
        results.add(call);
      }
    }
    return ListView.builder(
      itemCount: results.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ExpansionPanelList(
          dividerColor: Colors.transparent,
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
          elevation: 0.0,
          expansionCallback: (indexNo, isOpen) {
            /// Equates the the ScrollView recording index to the PanelList index.
            /// Sets the state of the recording tile to opposite of its current state when it is clicked.
            indexNo = index;
            _list[indexNo].isExpanded = !isOpen;
          },
          children: [
            ExpansionPanel(
              hasIcon: false,
              canTapOnHeader: true,
              isExpanded: _list[index].isExpanded,
              headerBuilder: (context, isExpanded) {
                return CollapsedRecordingTile(
                  isClicked: false,
                  isExpanded: results[index].isExpanded,
                  phone: results[index].phone,
                  caller: results[index].caller,
                  duration: results[index].duration,
                  datetime: results[index].datetime,
                );
              },
              body: ExpandedRecordingTile(
                isExpanded: results[index].isExpanded,
                sliderValue: 2,
                timeElapsed: '1:05',
                timeRemained: '-8:15',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.indigo,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.indigo,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      hintColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
