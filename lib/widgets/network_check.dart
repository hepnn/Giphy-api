import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:giphyfetch/screens/network%20_status.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget(
      {Key? key, required this.onlineChild, required this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.Online) {
      return onlineChild;
    } else {
      showToastMessage("Offline");
      return offlineChild;
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }
}
