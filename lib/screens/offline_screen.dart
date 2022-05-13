import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Internet Connection!",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const Icon(Icons.signal_wifi_connected_no_internet_4_rounded,
                size: 100, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
