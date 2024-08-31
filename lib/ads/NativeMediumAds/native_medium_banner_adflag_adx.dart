import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeMediumAdFlagAdx extends StatefulWidget {
  const NativeMediumAdFlagAdx({Key? key}) : super(key: key);

  @override
  State<NativeMediumAdFlagAdx> createState() => _NativeMediumAdFlagAdmobState();
}

class _NativeMediumAdFlagAdmobState extends State<NativeMediumAdFlagAdx> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  bool _nativeAdFail = false;
  bool isFacebookAd = false;
  bool isFbAdFailToLoad = false;
  bool adsLoaded = false;
  bool adxAdsLoaded = false;

  var admobId = PreferenceUtils.getString(keyAdmobNative);
  var fbNativeId = PreferenceUtils.getString(keyFbNative);

  Widget? fbNativeAds;

  @override
  Widget build(BuildContext context) {
    return showAds();
  }

  showAds() {
    final NativeAd? nativeAd = _nativeAd;

    print("adsLoaded $adsLoaded &&  isFacebookAd $isFacebookAd  && adsLoaded $adsLoaded && isFbAdFailToLoad $isFbAdFailToLoad)");

    if (!isFbAdFailToLoad) {
      log("loaded ----------- facebook");
      return fbNativeLoad();
    } else if (_nativeAdIsLoaded) {
      log("loaded ----------- admob");

      return _nativeAdIsLoaded && nativeAd != null
          ? ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 320, // minimum recommended width
                minHeight: 260, // minimum recommended height
                maxWidth: double.maxFinite,
                maxHeight: 300,
              ),
              child: AdWidget(ad: nativeAd),
            )
          : Container();
    } else {
      return const SizedBox.shrink();
    }
  }

  admobLoadNative() {
    _nativeAd = NativeAd(
      adUnitId: admobId,

      // adUnitId: PreferenceUtils.getPreferencesStringData("keyAdmobNative"),
      request: AdRequest(),
      factoryId: 'listTile',
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

          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  fbNativeLoad() {
    return FacebookNativeAd(
      // placementId: "YOUR_PLACEMENT_ID"
      placementId: fbNativeId,
      adType: NativeAdType.NATIVE_AD_HORIZONTAL,
      width: double.infinity,
      height: 250,
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

          admobLoadNative();
        }
      },
      keepExpandedWhileLoading: true,

      expandAnimationDuraion: 1000,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }
}
