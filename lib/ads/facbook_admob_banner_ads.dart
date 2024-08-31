import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FacebookAdmobBannerAds extends StatefulWidget {
  const FacebookAdmobBannerAds({Key? key}) : super(key: key);

  @override
  State<FacebookAdmobBannerAds> createState() => _FacebookAdmobBannerAdsState();
}

class _FacebookAdmobBannerAdsState extends State<FacebookAdmobBannerAds> {
  var admobAdId = PreferenceUtils.getString(keyAdmobBanner);
  var facebookAdId = PreferenceUtils.getString(keyFbBanner);
  BannerAd? anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  bool showAdmobAd = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
  }

  Future<void> loadBannerAd() async {
    log("ads ---- admob load $showAdmobAd  qureka");
    await anchoredAdaptiveAd?.dispose();
    setState(() {
      anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    anchoredAdaptiveAd = BannerAd(
      adUnitId: admobAdId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('error====${error.message}');
        },
      ),
    )..load();
    return anchoredAdaptiveAd!.load();
  }

  Widget getBannerAdWidget() {
    log("ads ---- FACEBOOK load");

    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation && anchoredAdaptiveAd != null && _isLoaded && showAdmobAd) {
          return Container(width: anchoredAdaptiveAd!.size.width.toDouble(), height: anchoredAdaptiveAd!.size.height.toDouble(), child: AdWidget(ad: anchoredAdaptiveAd!));
          // } else if (_showQreka) {
          //   return PreferenceUtils.getString(keyQureka) == 'predchamp'
          //       ? PredchampBannerAd()
          //       : QurekaBannerAd();
        }
        return FacebookBannerAd(
          placementId: facebookAdId, //testid
          bannerSize: BannerSize.STANDARD,
          listener: (result, value) {
            if (result == BannerAdResult.LOADED) {
              log("ads ---- fb load $showAdmobAd");

              log("ads ----- fb loaded");
              setState(() {
                showAdmobAd = false;
              });
            } else if (result == BannerAdResult.ERROR) {
              log("ads ---- fb fail $showAdmobAd ");

              loadBannerAd();
              setState(() {
                showAdmobAd = true;
              });
              log("ads ---- fb fail $showAdmobAd");
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => getBannerAdWidget();
}
