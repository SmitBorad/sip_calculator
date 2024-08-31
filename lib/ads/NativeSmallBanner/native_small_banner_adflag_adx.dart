import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeSmallBannerAdFlagAdx extends StatefulWidget {
  const NativeSmallBannerAdFlagAdx({Key? key}) : super(key: key);

  @override
  State<NativeSmallBannerAdFlagAdx> createState() => _NativeSmallBannerAdFlagAdxState();
}

class _NativeSmallBannerAdFlagAdxState extends State<NativeSmallBannerAdFlagAdx> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  bool _nativeAdFail = false;
  bool _showQreka = false;
  bool isFacebookAd = false;
  bool isFbAdFailToLoad = false;
  bool adsLoaded = false;

  var admobId = PreferenceUtils.getString(keyAdmobNative);
  var fbNativeId = PreferenceUtils.getString(keyFbNative);
  Widget? fbNativeAds;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green.shade200,
        // width: 250,
        height: 100,
        // height: widget.nativeAdType.toString() == 'adFactoryExample' ? 350 : 100,
        child: showAds());
  }

  showAds() {
    final NativeAd? nativeAd = _nativeAd;

    print("adsLoaded $adsLoaded &&  isFacebookAd $isFacebookAd  && adsLoaded $adsLoaded &&_showQreka $_showQreka && isFbAdFailToLoad $isFbAdFailToLoad)");

    if (!isFbAdFailToLoad) {
      log("loaded ----------- facebook");
      return fbNativeLoad();
    } else if (_nativeAdIsLoaded) {
      log("loaded ----------- admob");

      return _nativeAdIsLoaded && nativeAd != null ? AdWidget(ad: nativeAd) : Container();
    } else {
      return const SizedBox.shrink();
    }
  }

  admobLoadNative() {
    _nativeAd = NativeAd(
      adUnitId: admobId,

      // adUnitId: PreferencesHelper().getPreferencesStringData("keyAdmobNative"),
      request: const AdRequest(),
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
          setState(() {
            _showQreka = true;
          });
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  fbNativeLoad() {
    return FacebookNativeAd(
      placementId: fbNativeId,
      adType: NativeAdType.NATIVE_BANNER_AD,
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

          admobLoadNative();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }
}
