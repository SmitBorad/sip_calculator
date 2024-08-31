import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter_sip_calculator/mobile_layout.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'ads/app_open_ad.dart';
import 'home_screen.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getAds() async {
    PreferenceUtils.setBool(isAdLoadedAndShown, false);

    await AppOpenAds().loadAd(isSplash: true);
  }

  getSplashData() async {
    await getAds();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(const HomeScreen());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSplashData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff322E54),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            decoration: const BoxDecoration(color: Color(0xff322E54), image: DecorationImage(image: AssetImage("assets/images/Sal.png"))),
          ),
        ],
      ),
    );
  }
}
