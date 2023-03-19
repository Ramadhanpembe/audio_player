import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<String> _list = ['Ramadhan', 'Khamis', 'Kassim', 'Amour'];

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
    List<String> results = [];
    for (var name in _list) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        results.add(name);
      }
    }
    return ListView.builder(
      itemCount: results.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Text('Name $index');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> results = [];
    for (var name in _list) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        results.add(name);
      }
    }
    return ListView.builder(
      itemCount: results.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Text('Name $index');
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
