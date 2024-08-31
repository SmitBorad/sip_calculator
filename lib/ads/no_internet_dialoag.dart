import 'dart:ui';

import 'package:flutter/material.dart';

Dialog NoInternetDialog(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    child: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Card(
          elevation: 6,
          color: Colors.white,
          shadowColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/images/Sal.png', height: 80)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "No Internet Connection!",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Sorry, Your need an active internet connection to access this Application",
                  style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
