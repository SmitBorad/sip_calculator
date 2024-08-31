import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter_sip_calculator/ads/no_internet_dialoag.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'package:flutter_sip_calculator/spalesh_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'mobile_layout.dart';
import 'service/firebase_remote_config_services.dart';
import 'windows_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await PreferenceUtils.init();
  MobileAds.instance.initialize();
  FacebookAudienceNetwork.init();

  try {
    await FirebaseRemoteConfigService().initialize();
  } catch (e) {
    log("ERROR ON REMOTE $e");
  }
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    Connectivity().onConnectivityChanged.listen(
      (event) {
        if (event == ConnectivityResult.none) {
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
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIP Calculator',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bool _isDesktop =
      defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || kIsWeb;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff322E54)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPopInterstitialAds(context: context);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Ads.adaptiveBanner(),
        body: _isDesktop ? const WindowsLayout() : const SafeArea(child: MobileLayout()),
      ),
    );
  }
}
