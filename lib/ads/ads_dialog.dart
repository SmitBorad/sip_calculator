import 'dart:convert';

import 'package:flutter/material.dart';

Future showLoader(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (_, __, ___) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.height / 5.5,
              decoration: BoxDecoration(color: const Color(0xff322E54), borderRadius: BorderRadius.circular(10)),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                      child: Text(
                    "Loading Ads...",
                    style: TextStyle(color: Colors.white),
                  )),
                  SizedBox(height: 24),
                ],
              )),
        ),
      );
    },
  );

  /*showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: colorFFFFFF,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.height / 7,
                height: MediaQuery.of(context).size.height / 7,
              ),
              // Center(
              //   child: Lottie.asset(
              //     'assets/loader.json',
              //     width: MediaQuery.of(context).size.height / 7,
              //     height: MediaQuery.of(context).size.height / 7,
              //   ),
              // ),
              const SizedBox(height: 2),
              Center(
                  child: Text(
                "Loading Ads...".tr,
                style: color000000s14w500,
              )),
              const SizedBox(height: 16),
            ],
          )
        ],
      );
    },
  );*/
}
