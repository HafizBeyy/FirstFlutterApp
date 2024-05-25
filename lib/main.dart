import "package:english_words/english_words.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  //* app-level widget
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Namer App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 222, 7)),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favoriteWords = <WordPair>[];
  void toggleFavorite() {
    if (favoriteWords.contains(current)) {
      favoriteWords.remove(current);
    } else {
      favoriteWords.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text("Home")),
              NavigationRailDestination(
                  icon: Icon(Icons.favorite), label: Text("Favorites"))
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          )),
          Expanded(
              child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const GeneratorPage(),
          ))
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.current;
    IconData icon;
    if (appState.favoriteWords.contains(wordPair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PairWords(wordPair: wordPair),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  label: const Text("Like"),
                  icon: Icon(icon)),
              const SizedBox(width: 15),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  //* button's style
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromRGBO(144, 0, 255, 1), width: 2.0)),
                  child: const Text("Next Word",
                      style: TextStyle(color: Color.fromRGBO(144, 0, 255, 1)))),
            ],
          )
        ],
      ),
    ));
  }
}

class PairWords extends StatelessWidget {
  const PairWords({
    super.key,
    required this.wordPair,
  });
  final WordPair wordPair;

  @override
  //* for PairWords widget only
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(wordPair.asCamelCase,
            style: style, semanticsLabel: wordPair.asPascalCase),
      ),
    );
  }
}
