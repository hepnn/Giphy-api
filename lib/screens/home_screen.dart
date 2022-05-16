import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giphyfetch/const.dart';
import 'package:giphyfetch/screens/gif_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late String _search = '';
  int _offset = 0;

  _widgetTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: "Search for...",
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.search),
          suffix: GestureDetector(
            onTap: () {
              _controller.clear();
            },
            child: const Icon(Icons.clear),
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 18.0),
        onChanged: (text) {
          setState(() {
            _offset = 0;
            _search = text;
          });
        },
      ),
    );
  }

  _widgetProgress() {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 5.0,
      ),
    );
  }

  _widgetError() {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      child: const Text("Error fetching GIFs"),
    );
  }

  _noResults() {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      child: const Text(
        "No results",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _widgetGridView(BuildContext context, AsyncSnapshot? snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot!.data["data"]),
        itemBuilder: (context, index) {
          if (index < snapshot.data["data"].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GiphyPageDetail(snapshot.data["data"][index])));
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
            );
          } else {
            return TextButton(
              child: const Text("Load more"),
              onPressed: () {
                setState(() {
                  _offset += 19;
                });
              },
            );
          }
        });
  }

  int _getCount(List? data) {
    if (_search.isEmpty) {
      return data!.length;
    } else {
      return data!.length + 1;
    }
  }

  _widgetFutureBuilder(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
      future: fetchGifs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return _widgetProgress();
          case ConnectionState.done:
          case ConnectionState.active:
          default:
            if (snapshot.hasData) {
              return _widgetGridView(context, snapshot);
            } else if (snapshot.hasError) {
              return _widgetError();
            } else {
              return _noResults();
            }
        }
      },
    ));
  }

  Future<Map> fetchGifs() async {
    Map? result;

    var urlSearch = Uri.https(Constant.baseURL,
        Constant.baseVERSION + Constant.baseGIFS + Constant.baseSEARCH, {
      'api_key': Constant.apiKEY,
      'q': _search,
      'limit': '19', // limit search to X gifs shown
      'offset': '$_offset',
      'rating': 'G',
      'lang': 'en'
    });

    var urlTrending = Uri.https(Constant.baseURL,
        Constant.baseVERSION + Constant.baseGIFS + Constant.baseTRENDING, {
      'api_key': Constant.apiKEY,
      'limit': '50', //  limit of the number of gifs to be shown
    });

    http.Response response;

    if (_search.isEmpty) {
      response = await http.Client().get(urlTrending);
    } else {
      response = await http.Client().get(urlSearch);
    }

    try {
      if (response.statusCode == 200) {
        result = json.decode(response.body);
      } else {
        throw Exception('Failed to load gifs');
      }
      result = json.decode(response.body);
    } on Exception catch (_, ex) {
      result = ex.toString() as Map;
    }

    return result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[_widgetTextField(), _widgetFutureBuilder(context)],
      ),
    );
  }
}
