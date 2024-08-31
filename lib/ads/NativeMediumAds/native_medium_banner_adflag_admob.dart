import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeMediumAdFlagAdmob extends StatefulWidget {
  const NativeMediumAdFlagAdmob({Key? key}) : super(key: key);

  @override
  State<NativeMediumAdFlagAdmob> createState() => _NativeMediumAdFlagAdmobState();
}

class _NativeMediumAdFlagAdmobState extends State<NativeMediumAdFlagAdmob> {
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
      request: const AdRequest(),
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

      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Theme.of(context).colorScheme.primary,
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
    final NativeAd? nativeAd = _nativeAd;
    print("adsLoaded $adsLoaded &&  isFacebookAd $isFacebookAd  && adsLoaded $adsLoaded  && isFbAdFailToLoad $isFbAdFailToLoad)");
    if (_nativeAdIsLoaded) {
      return _nativeAdIsLoaded && (nativeAd != null)
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 320, // minimum recommended width
                minHeight: 260, // minimum recommended height
                maxWidth: double.maxFinite,
                maxHeight: 300,
              ),
              child: AdWidget(ad: nativeAd),
            )
          : Container();
    } else if (_nativeAdFail && !isFbAdFailToLoad) {
      return SizedBox(
        height: 340,
        child: fbNativeLoad(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
