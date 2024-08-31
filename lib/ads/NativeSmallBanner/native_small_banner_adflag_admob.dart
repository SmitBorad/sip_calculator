import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeSmallBannerAdMob extends StatefulWidget {
  const NativeSmallBannerAdMob({Key? key}) : super(key: key);

  @override
  State<NativeSmallBannerAdMob> createState() => _NativeSmallBannerAdMobState();
}

class _NativeSmallBannerAdMobState extends State<NativeSmallBannerAdMob> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  bool _nativeAdFail = false;
  bool isFacebookAd = false;
  bool isFbAdFailToLoad = false;
  bool adsLoaded = false;

//  var admobId = 'ddfg';
  var admobId = PreferenceUtils.getString(keyAdmobNative);
  //var fbNativeId = 'zsxfsdf';
  var fbNativeId = PreferenceUtils.getString(keyFbNative);
  Widget? fbNativeAds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      admobLoadNative();
    });
  }

  void admobLoadNative() {
    if (_nativeAd != null) {
      _nativeAd = null;
      _nativeAd!.dispose();
    }
    _nativeAd = NativeAd(
      adUnitId: admobId,

      // adUnitId:PreferenceUtils.getString("keyAdmobNative"),
      request: AdRequest(),
      factoryId: 'adSmall',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          setState(() {
            _nativeAdFail = true;
          });
          //adx Native
          log("isFacebookAd$isFacebookAd");
          fbNativeLoad();
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showAds();
  }

  FacebookNativeAd fbNativeLoad() {
    return FacebookNativeAd(
      // placementId: "YOUR_PLACEMENT_ID"
      placementId: fbNativeId,
      adType: NativeAdType.NATIVE_BANNER_AD,
      height: 300,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Colors.green.shade200,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.green,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        if (result == NativeAdResult.LOADED) {
          setState(() {
            isFacebookAd = true;
          });
          print("-*/-*/-*/isFacebookAd---$isFacebookAd");
        } else if (result == NativeAdResult.ERROR) {
          setState(() {
            isFbAdFailToLoad = true;
          });
          print("-*/-*/-*/isFbAdFailToLoad---$isFbAdFailToLoad");
          print("-*/-*/-*/isFbAdFailToLoad---$value");
        }
      },
    );
  }

  showAds() {
    print("adsLoaded $adsLoaded &&  isFacebookAd $isFacebookAd  && adsLoaded $adsLoaded && isFbAdFailToLoad $isFbAdFailToLoad)");
    if (_nativeAdIsLoaded) {
      return _nativeAdIsLoaded && _nativeAd != null
          ? Container(color: Colors.green.shade200, height: 100, width: double.maxFinite, child: AdWidget(ad: _nativeAd!))
          : const SizedBox.shrink();
    } else if (_nativeAdFail && !isFbAdFailToLoad) {
      return Container(color: Colors.green.shade200, height: 100, child: fbNativeLoad());
    } else {
      return const SizedBox.shrink();
    }
  }
}
