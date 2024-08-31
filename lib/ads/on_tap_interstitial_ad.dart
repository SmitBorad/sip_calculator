import 'dart:developer';
import 'dart:math' as random;

import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/Utils/common_functions.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/app_images.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_dialog.dart';

int curruntCount = 1;
int maxClickCount = int.tryParse(PreferenceUtils.getString(keyClick).toString())!;
int Alt_Cnt_Interstitial = 1;

var admobId = PreferenceUtils.getString(keyAdmobFull);
var admobReward = PreferenceUtils.getString(keyAdmobReward);
var fbFullid = PreferenceUtils.getString(keyFbFull);
bool isAdLoaded = false;

int adtime = int.tryParse(PreferenceUtils.getString(keyAdTime).toString())!;

int tabClickcount = int.tryParse(PreferenceUtils.getString(keyClick).toString()) ?? 0;
int tabClickCounter = 1;
detailsScreenOnTap(BuildContext context, Function onTap) {
  print("financial click ---- tapped");
  print("finalCount click ---- $tabClickcount");

  onTapInterstitialAds(context, onTap);

  print("tabClickCounter click ---- $tabClickCounter");
}

void onTapInterstitialAds(BuildContext context, Function onTap) {
  if (PreferenceUtils.getString(keyAdStatus) == 'on') {
    if (PreferenceUtils.getString(keyClickFlag).toLowerCase() == 'on') {
      print("ads ----- CurruntCouhnt on TAP = $curruntCount MaxCount = $maxClickCount");
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
              if (PreferenceUtils.getString(keyAdReward) == 'on') {
                ///load Reward Ad
                log(PreferenceUtils.getString(keyAdReward), name: "ISREWARD");
                admobRewardedAdsForOnTap(context, onTap);
              } else {
                admobInterstitialAdsForOnTap(context, onTap);
              }
              log("ADMOB SMIT");
            } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
              log("ADX SMIT");

              fbinterstitialAdForOnTap(context, onTap);
            }
          } else if (PreferenceUtils.getString(keyAdStyle) == 'ALT') {
            print("ads ----${Alt_Cnt_Interstitial}");
            if (curruntCount >= maxClickCount) {
              if (Alt_Cnt_Interstitial == 2) {
                Alt_Cnt_Interstitial = 1;
                admobInterstitialAdsForOnTap(context, onTap);
              } else {
                Alt_Cnt_Interstitial++;
                fbinterstitialAdForOnTap(context, onTap);
              }
            }
          }
        }
      } else {
        onTap();
      }
      curruntCount++;
    } else if (PreferenceUtils.getString(keyClickFlag).toLowerCase() == 'off') {
      print("ADS ---- CLICKFALG OFF");

      if (PreferenceUtils.getString(keyTapTime) != "" && DateTime.now().difference(DateTime.parse(PreferenceUtils.getString(keyTapTime))).inSeconds < adtime) {
        onTap();
      } else {
        showLoader(context);
        PreferenceUtils.setString(keyTapTime, DateTime.now().toString());
        if (PreferenceUtils.getString(keyAdStyle) == 'normal') {
          if (PreferenceUtils.getString(keyAdFlag) == "admob") {
            print("ADS ---- admob");
            admobInterstitialAdsForOnTap(context, onTap);
          } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
            print("ADS ---- adx");
            fbinterstitialAdForOnTap(context, onTap);

            // navigation
          } else {
            onTap();
          }
        } else if (PreferenceUtils.getString(keyAdStyle) == 'ALT') {
          if (Alt_Cnt_Interstitial == 2) {
            Alt_Cnt_Interstitial = 1;
            admobInterstitialAdsForOnTap(context, onTap);
          } else {
            Alt_Cnt_Interstitial++;
            fbinterstitialAdForOnTap(context, onTap);
          }
        } else {
          onTap();
        }
      }
    } else {
      onTap();
    }
  } else {
    onTap();
  }
  print("ads ----- CurruntCouhnt = $curruntCount MaxCount = $maxClickCount");
}

void admobInterstitialAdsForOnTap(BuildContext context, Function onTap) {
  InterstitialAd.load(
      adUnitId: admobId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Navigator.pop(context);

          log("onAdLoaded admobInterstitialAds ads ----");

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Navigator.of(context).pop();
              onTap();

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
                Navigator.pop(context);

                FacebookInterstitialAd.showInterstitialAd();
              }
              if (result == InterstitialAdResult.ERROR) {
                Navigator.pop(context);
                onTap();

                curruntCount = 1;
              }
              if (result == InterstitialAdResult.DISMISSED) {
                Navigator.pop(context);
                onTap();

                ///navigation
                curruntCount = 1;
              }
            },
          );
        },
      ));
}

void admobRewardedAdsForOnTap(BuildContext context, Function onTap) {
  RewardedAd.load(
    adUnitId: admobReward,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        log("onAdLoaded admobRewardedAds ads ----");

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            Navigator.of(context).pop();
            onTap();

            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            curruntCount = 1;
          },
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            log("onAdFailedToShowFullScreenContent admobRewardedAds ads ----");

            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
          },
        );

        ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $reward');
          // Handle reward here, for example:
          // reward.amount (e.g., 10)
          // reward.type (e.g., "coins")
        });
      },
      onAdFailedToLoad: (LoadAdError error) {
        log("onAdFailedToLoad admobRewardedAds ads ----");
        admobInterstitialAdsForOnTap(context, onTap);
      },
    ),
  );
}

void fbinterstitialAdForOnTap(BuildContext context, Function onTap) {
  print("ADS ---- fbinterstitialAd");
  print("ADS ---- HELLO");
  print("ADS ----AD ID $fbFullid");
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
        print('on tap ==error---${value}');
        print("ADS ---- FB ERROR");

        InterstitialAd.load(
            adUnitId: admobId,
            request: AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (InterstitialAd ad) {
                    Navigator.of(context).pop();
                    onTap();

                    curruntCount = 1;
                    ad.dispose();

                    ///navigation
                  },
                  onAdShowedFullScreenContent: (InterstitialAd ad) {},
                  onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                    Navigator.of(context).pop();
                    onTap();
                    print('$ad onAdFailedToShowFullScreenContent: $error');
                    ad.dispose();
                  },
                );
                ad.show();
              },
              onAdFailedToLoad: (LoadAdError error) {
                Navigator.of(context).pop();
                onTap();
                curruntCount = 1;
              },
            ));
      }
      if (result == InterstitialAdResult.DISMISSED) {
        Navigator.of(context).pop();
        onTap();
        curruntCount = 1;
      }
    },
  );
}

class FullScreenAd extends StatelessWidget {
  final Function onTap;
  FullScreenAd({required this.onTap});

  List adsImage = [
    qureka_inter_1,
    qureka_inter_2,
    qureka_inter_3,
    qureka_inter_4,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              qurekaRedirect();
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                adsImage[random.Random().nextInt(4)], // Replace this with your image path
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            right: 20.0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.close),
                iconSize: 20,
                color: Colors.black,
                onPressed: () {
                  Get.back();
                  onTap();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
