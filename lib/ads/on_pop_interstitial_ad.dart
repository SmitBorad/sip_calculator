import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/Utils/common_functions.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/on_tap_interstitial_ad.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_dialog.dart';

int curruntCount = 1;
int maxClickCount = int.tryParse(PreferenceUtils.getString(keyBackClick).toString()) ?? 0;
int Alt_Cnt_Interstitial = 1;

var admobId = PreferenceUtils.getString(keyAdmobFull);
var admobReward = PreferenceUtils.getString(keyAdmobReward);

var fbFullid = PreferenceUtils.getString(keyFbFull);
bool isAdLoaded = false;
int adtime = int.tryParse(PreferenceUtils.getString(keyAdTime))!;

onPopInterstitialAds({required BuildContext context, bool isBackValue = false, var backValue}) async {
  print("111111111111111${PreferenceUtils.getString(keyAdStatus)}");
  print("ads ----- CurruntCouhnt = $curruntCount MaxCount = $maxClickCount");
  if (PreferenceUtils.getString(keyAdStatus) == 'on') {
    if (PreferenceUtils.getString(keyBackFlag).toString().toLowerCase() == 'on') {
      print("ads ----- CurruntCouhnt = $curruntCount MaxCount = $maxClickCount");
      if (curruntCount > maxClickCount) {
        curruntCount = 1;
      }
      if (curruntCount >= maxClickCount) {
        if (PreferenceUtils.getString(qurekaInter).toLowerCase() == "on") {
          /* showDialog(
            context: context,
            builder: (BuildContext context) {
              return FullScreenAd(
                onTap: onTap,
              );
            },
          );*/
          if (PreferenceUtils.getString(qurekaRedirectShort).toLowerCase() == 'on') {
            qurekaRedirect();
          } else {
            Get.to(FullScreenAd(
              onTap: () {
                Get.back();
              },
            ));
          }
        } else {
          showLoader(context);
          if (PreferenceUtils.getString(keyAdStyle) == 'normal') {
            if (PreferenceUtils.getString(keyAdFlag) == "admob") {
              if (PreferenceUtils.getString(keyAdBackReward) == "on") {
                admobRewardedAds(context: context, backValue: backValue, isBackValue: isBackValue);
              } else {
                admobInterstitialAds(context: context, backValue: backValue, isBackValue: isBackValue);
              }
            } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
              fbinterstitialAd(context: context, backValue: backValue, isBackValue: isBackValue);
            }
          } else if (PreferenceUtils.getString(keyAdStyle) == 'ALT') {
            print("ads ----${Alt_Cnt_Interstitial}");
            if (curruntCount >= maxClickCount) {
              if (Alt_Cnt_Interstitial == 2) {
                Alt_Cnt_Interstitial = 1;
                admobInterstitialAds(context: context, backValue: backValue, isBackValue: isBackValue);
              } else {
                Alt_Cnt_Interstitial++;
                fbinterstitialAd(context: context, backValue: backValue, isBackValue: isBackValue);
              }
            }
          }
        }
      } else {
        Navigator.of(context).pop();
      }
      curruntCount++;
    } else if (PreferenceUtils.getString(keyBackFlag).toString().toLowerCase() == 'off') {
      print("ADS ---- CLICKFALG OFF");
      if (PreferenceUtils.getString(keyTapTime) != "" && DateTime.now().difference(DateTime.parse(PreferenceUtils.getString(keyTapTime).toString())).inSeconds < adtime) {
        Navigator.of(context).pop();
      } else {
        showLoader(context);
        PreferenceUtils.setString(keyTapTime, DateTime.now().toString());
        if (PreferenceUtils.getString(keyAdStyle) == 'normal') {
          if (PreferenceUtils.getString(keyAdFlag) == "admob") {
            admobInterstitialAds(context: context, backValue: backValue, isBackValue: isBackValue);
          } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
            fbinterstitialAd(context: context, backValue: backValue, isBackValue: isBackValue);
          }
        } else if (PreferenceUtils.getString(keyAdStyle) == 'ALT') {
          if (Alt_Cnt_Interstitial == 2) {
            Alt_Cnt_Interstitial = 1;
            admobInterstitialAds(context: context, backValue: backValue, isBackValue: isBackValue);
          } else {
            Alt_Cnt_Interstitial++;
            fbinterstitialAd(context: context, backValue: backValue, isBackValue: isBackValue);
          }
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      Navigator.of(context).pop();
    }
  } else {
    Navigator.of(context).pop();
  }
}

void fbinterstitialAd({required BuildContext context, required backValue, required bool isBackValue}) {
  print("ADS ---- fbinterstitialAd");
  FacebookInterstitialAd.showInterstitialAd();
  FacebookInterstitialAd.loadInterstitialAd(
    placementId: fbFullid,
    listener: (result, value) {
      print("ADS ---- fb listener");

      print(">> FAN > Interstitial Ad: $result --> $value");
      if (result == InterstitialAdResult.LOADED) {
        print("ADS ---- FB LOADED");
        FacebookInterstitialAd.showInterstitialAd();
      }
      if (result == InterstitialAdResult.ERROR) {
        print("ADS ---- FB ERROR");

        InterstitialAd.load(
            adUnitId: admobId,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (InterstitialAd ad) {
                    Navigator.of(context).pop();
                    isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();
                    curruntCount = 1;
                    ad.dispose();

                    ///navigation
                  },
                  onAdShowedFullScreenContent: (InterstitialAd ad) {},
                  onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                    print('$ad onAdFailedToShowFullScreenContent: $error');
                    ad.dispose();
                  },
                );
                ad.show();
              },
              onAdFailedToLoad: (LoadAdError error) {
                Navigator.of(context).pop();
                isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();

                curruntCount = 1;
              },
            ));
      }
      if (result == InterstitialAdResult.DISMISSED) {
        Navigator.of(context).pop();
        isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();

        curruntCount = 1;
      }
    },
  );
}

void admobInterstitialAds({required BuildContext context, required backValue, required bool isBackValue}) {
  InterstitialAd.load(
      adUnitId: admobId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Navigator.pop(context);

          log("onAdLoaded admobInterstitialAds ads ----");

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Navigator.of(context).pop();
              isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();

              print('$ad onAdDismissedFullScreenContent.');

              ad.dispose();
              curruntCount = 1;

              ///navigation
            },
            onAdShowedFullScreenContent: (InterstitialAd ad) {},
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              log("onAdFailedToShowFullScreenContent admobInterstitialAds ads ----");

              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          FacebookInterstitialAd.loadInterstitialAd(
            placementId: fbFullid,
            listener: (result, value) {
              print(">> FAN > Interstitial Ad: $result --> $value");
              if (result == InterstitialAdResult.LOADED) {
                // Navigator.pop(context);

                FacebookInterstitialAd.showInterstitialAd();
              }
              if (result == InterstitialAdResult.ERROR) {
                // Navigator.pop(context);
                Navigator.of(context).pop();
                isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();

                curruntCount = 1;
              }
              if (result == InterstitialAdResult.DISMISSED) {
                Navigator.of(context).pop();
                isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();

                ///navigation
                curruntCount = 1;
              }
            },
          );
        },
      ));
}

void admobRewardedAds({required BuildContext context, required backValue, required bool isBackValue}) {
  RewardedAd.load(
    adUnitId: admobReward,
    request: AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        log("onAdLoaded admobRewardedAds ads ----");

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            Navigator.of(context).pop();
            isBackValue ? Navigator.of(context).pop(backValue) : Navigator.of(context).pop();

            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            curruntCount = 1;

            /// navigation or additional actions can be handled here
          },
          onAdShowedFullScreenContent: (RewardedAd ad) {},
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            log("onAdFailedToShowFullScreenContent admobRewardedAds ads ----");

            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
          },
        );

        ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          // Handle reward here, if necessary.
        });
      },
      onAdFailedToLoad: (LoadAdError error) {
        log("onAdFailedToLoad admobRewardedAds ads ----");

        admobInterstitialAds(context: context, backValue: backValue, isBackValue: isBackValue);
      },
    ),
  );
}
