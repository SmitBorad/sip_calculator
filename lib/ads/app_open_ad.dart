import 'dart:convert';
import 'dart:developer';

import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAds {
  AppOpenAd? _appOpenAd;
  bool _isAdLoadedAndShown = PreferenceUtils.getBool(isAdLoadedAndShown);

  Future loadAd({bool isSplash = false}) async {
    log("APP OPEN :LOAD");
    _appOpenAd?.dispose();

    if (!_isAdLoadedAndShown &&
        jsonDecode(PreferenceUtils.getString(keyAdsJsonData) == "" ? {}.toString() : PreferenceUtils.getString(keyAdsJsonData))['json_data']?['Data']?[0]?['open']
                .toString()
                .toLowerCase() ==
            "on" &&
        jsonDecode(PreferenceUtils.getString(keyAdsJsonData))['json_data']['Data'][0]['Adstatus'].toString().toLowerCase() == "on") {
      await AppOpenAd.load(
        adUnitId: isSplash
            ? jsonDecode(PreferenceUtils.getString(keyAdsJsonData))['json_data']['Data'][0]['admob-splash-open'].toString()
            : jsonDecode(PreferenceUtils.getString(keyAdsJsonData))['json_data']['Data'][0]['admob-open'].toString(),
        request: const AdRequest(),
        orientation: AppOpenAd.orientationPortrait,
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            log("APP OPEN: LOADED");
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                PreferenceUtils.setBool(isAdLoadedAndShown, false);
                log(PreferenceUtils.getBool(isAdLoadedAndShown).toString(), name: "_isAdLoadedAndShown");
              },
              onAdShowedFullScreenContent: (ad) {
                PreferenceUtils.setBool(isAdLoadedAndShown, true);

                log(PreferenceUtils.getBool(isAdLoadedAndShown).toString(), name: "_isAdLoadedAndShown");
              },
              onAdFailedToShowFullScreenContent: (ad, error) {},
            );

            _appOpenAd?.show();
          },
          onAdFailedToLoad: (error) {
            print('AppOpenAd failed to load: $error');
            // Handle the error.
          },
        ),
      );
    }
  }
}
