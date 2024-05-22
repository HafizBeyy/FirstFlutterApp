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
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 222, 7)),
        ),
        home: MyHomePage(),
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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PairWords(wordPair: wordPair),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text("Next Word",
                    style: TextStyle(color: Color.fromRGBO(144, 0, 255, 1))),
                    //* button's style
                style: ElevatedButton.styleFrom(
                  ,
                  side: BorderSide(
                      color: Color.fromRGBO(144, 0, 255, 1),
                      width: 2.0)
                ))
          ],
        ),
      ),
    );
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
