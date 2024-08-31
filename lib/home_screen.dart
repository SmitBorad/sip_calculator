import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/app_open_ad.dart';
import 'package:flutter_sip_calculator/ads/no_internet_dialoag.dart';
import 'package:flutter_sip_calculator/ads/on_tap_interstitial_ad.dart';
import 'package:flutter_sip_calculator/main.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'mobile_layout.dart';
import 'new_calculator_screen.dart';

bool emiView = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      log("message");
      /*toast("Please Check Internet Connection");*/

      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return NoInternetDialog(context);
        },
      );
    } else {
      while (Navigator.canPop(navigatorKey.currentContext!)) {
        Navigator.pop(navigatorKey.currentContext!);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // _loadPermission();
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        AppOpenAds().loadAd();

        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Ads.adaptiveBanner(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      // Get.to(const NewCalculatorScreen());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: const BoxDecoration(color: Color(0xff322E54), image: DecorationImage(image: AssetImage("assets/images/Sal.png"))),
                    ),
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 1.95),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                      color: Colors.white,
                    ),
                    // height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            detailsScreenOnTap(context, () {
                              setState(() {
                                Get.to(const MyHomePage(
                                  title: '',
                                ));
                                selectType = 0;
                                emiView = false;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(color: const Color(0xff322E54).withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Sip Calculator',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            detailsScreenOnTap(context, () {
                              setState(() {
                                Get.to(const MyHomePage(
                                  title: '',
                                ));
                                selectType = 1;
                                emiView = false;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(color: const Color(0xff322E54).withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Lumpsum Calculator',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            detailsScreenOnTap(context, () {
                              setState(() {
                                Get.to(const MyHomePage(
                                  title: '',
                                ));
                                selectType = 2;
                                emiView = true;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(color: const Color(0xff322E54).withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'EMI Calculator',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            detailsScreenOnTap(context, () {
                              Get.to(const NewCalculatorScreen());
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(color: const Color(0xff322E54).withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'More Calculator',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
