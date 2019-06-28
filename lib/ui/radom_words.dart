import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  static String sName = "/randomWords";

  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 16.0);

  final _saved = new Set<WordPair>();
  var _listCount = 20;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addOne,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 10),
                child: new Text("Random Word(${_suggestions.length})"),
              ),
              Builder(
                  builder: (context) => new IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => _pushSaved(context)))
            ],
          ),
          Expanded(child: _buildSuggestions())
        ],
      ),
    );
  }

  void addOne() {
    setState(() {
      _listCount++;
    });
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10),
      itemBuilder: (context, i) {
        if (i.isOdd)
          return new Divider(
            height: 1,
          );

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
      itemCount: _listCount * 2 - 1,
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
        textAlign: TextAlign.start,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      contentPadding: EdgeInsets.all(0),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved(context) async {
    var result = await Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new SavedWords(_saved)));

    if (result != null) {
      Scaffold.of(context, nullOk: true).showSnackBar(SnackBar(
        content: new Text("You tap $result"),
        duration: Duration(seconds: 1),
      ));
    }
  }

}

class SavedWords extends StatelessWidget {
  final Set<WordPair> _savedWords;

  SavedWords(this._savedWords);

  Widget build(BuildContext context) {
    final titles = _savedWords.map((pair) {
      return new ListTile(
        title: new Text(
          pair.asPascalCase,
        ),
        onTap: () => Navigator.pop(context, pair.asPascalCase),
      );
    });
    final divided =
        ListTile.divideTiles(tiles: titles, context: context).toList();
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Saved Suggestions(${_savedWords.length})',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }
}
