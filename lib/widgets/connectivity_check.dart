import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:giphyfetch/screens/network%20_status.dart';
import 'package:giphyfetch/screens/home_screen.dart';
import 'package:giphyfetch/screens/offline_screen.dart';
import 'package:giphyfetch/widgets/network_check.dart';
import 'package:provider/provider.dart';

class ConnectivityCheck extends StatelessWidget {
  const ConnectivityCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Giphy",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.Offline,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: const NetworkAwareWidget(
            onlineChild: HomeScreen(), offlineChild: OfflineScreen()),
      ),
    );
  }
}
