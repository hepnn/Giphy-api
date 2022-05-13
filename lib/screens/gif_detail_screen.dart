import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GiphyPageDetail extends StatelessWidget {
  final Map? _gifData;

  const GiphyPageDetail(this._gifData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Gif Details', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(_gifData!["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_gifData!["title"]),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
            ),
            Image.network(_gifData!["images"]["fixed_height"]["url"]),
          ],
        ),
      ),
    );
  }
}
