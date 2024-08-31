import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as random;
import 'package:flutter_sip_calculator/Utils/common_functions.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter_sip_calculator/ads/app_images.dart';

import 'NativeMediumAds/native_medium_banner_adflag_admob.dart';
import 'NativeMediumAds/native_medium_banner_adflag_adx.dart';
import 'NativeSmallBanner/native_small_banner_adflag_admob.dart';
import 'NativeSmallBanner/native_small_banner_adflag_adx.dart';
import 'admob_facbook_banner_ads.dart';
import 'facbook_admob_banner_ads.dart';

int Alt_Cnt_Banner = 1;
int Alt_Cnt_Native_Banner = 1;

class Ads {
  //Banner Ads
  static adaptiveBanner() {
    if (PreferenceUtils.getString(keyBannerOn) == 'on' && PreferenceUtils.getString(keyAdStatus) == "on") {
      if (PreferenceUtils.getString(qureka).toLowerCase() == "banner") {
        log("QUEREKA BANNER");
        List banners = [
          qureka_banner_1,
          qureka_banner_2,
          qureka_banner_3,
          qureka_banner4,
        ];
        return InkWell(
          onTap: () {
            qurekaRedirect();
          },
          child: Image.asset(
            banners[random.Random().nextInt(banners.length)],
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
        );
      } else {
        if (PreferenceUtils.getString(keyAdStyleBanner) == 'normal') {
          if (PreferenceUtils.getString(keyAdFlag) == "admob") {
            log("admob SMIT");
            return const AdmobFacebookBannerAd();
          } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
            log("ADX SMIT");

            return const FacebookAdmobBannerAds();
          }
        } else if (PreferenceUtils.getString(keyAdStyleBanner) == 'ALT') {
          if (Alt_Cnt_Banner == 2) {
            Alt_Cnt_Banner = 1;
            return const AdmobFacebookBannerAd();
          } else {
            Alt_Cnt_Banner++;
            return const FacebookAdmobBannerAds();
          }
        }
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  static nativeBannerAds() {
    log("adflag------${PreferenceUtils.getString(keyAdFlag)}");
    if (PreferenceUtils.getString(keyNativeOn) == 'on' && PreferenceUtils.getString(keyAdStatus) == "on") {
      if (PreferenceUtils.getString(qureka).toLowerCase() == "native") {
        List banners = [
          qureka_banner_1,
          qureka_banner_2,
          qureka_banner_3,
          qureka_banner4,
        ];
        return InkWell(
          onTap: () {
            qurekaRedirect();
          },
          child: Image.asset(
            banners[random.Random().nextInt(banners.length)],
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
        );
      } else {
        if (Platform.isAndroid) {
          log("-keyData-keyAdstyl1111111e-${PreferenceUtils.getString(keyAdStyleNative)}");
          log("-keyData-keyAdflag2222222-${PreferenceUtils.getString(keyAdFlag)}");
          if (PreferenceUtils.getString(keyAdStyleNative).toString() == "normal") {
            if (PreferenceUtils.getString(keyAdFlag).toString() == "admob") {
              return const NativeSmallBannerAdMob();
            } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
              return const NativeSmallBannerAdFlagAdx();
            }
          } else if (PreferenceUtils.getString(keyAdStyleNative) == 'ALT') {
            if (Alt_Cnt_Native_Banner == 2) {
              Alt_Cnt_Native_Banner = 1;
              return const NativeSmallBannerAdMob();
            } else {
              Alt_Cnt_Native_Banner++;
              return const NativeSmallBannerAdFlagAdx();
            }
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    } else {
      return const SizedBox();
    }
  }

  static nativeMediumAds() {
    log("-keyData-keyAdstyl1111111e-${PreferenceUtils.getString(keyNativeOn)}");
    if (PreferenceUtils.getString(keyNativeOn) == 'on' && PreferenceUtils.getString(keyAdStatus) == "on") {
      if (PreferenceUtils.getString(qureka).toLowerCase() == "native") {
        List natives = [
          qureka_native,
          qureka_native_2,
          qureka_native_3,
          qureka_native_4,
        ];
        log("QUEREKA NATIVE");
        return Container(
          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: const Text(
                    "Ad",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    qurekaRedirect();
                  },
                  child: Image.asset(
                    natives[random.Random().nextInt(natives.length)],
                    width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              PreferenceUtils.getString(qurekaRedirectIs).toString() == 'on'
                  ? const SizedBox(
                      height: 8,
                    )
                  : const SizedBox(),
              PreferenceUtils.getString(qurekaRedirectIs).toString() == 'on'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MaterialButton(
                        height: 45,
                        minWidth: double.maxFinite,
                        onPressed: () {
                          qurekaRedirect();
                        },
                        color: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: const Text("PLAY NOW", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    )
                  : const SizedBox(),
              PreferenceUtils.getString(qurekaRedirectIs).toString() == 'on'
                  ? const SizedBox(
                      height: 8,
                    )
                  : const SizedBox(),
            ],
          ),
        );
      } else {
        if (Platform.isAndroid) {
          log("-keyData-keyAdstyl1111111e-${PreferenceUtils.getString(keyAdStyleNative)}");
          log("-keyData-keyAdflag2222222-${PreferenceUtils.getString(keyAdFlag)}");
          if (PreferenceUtils.getString(keyAdStyleNative).toString() == "normal") {
            if (PreferenceUtils.getString(keyAdFlag).toString() == "admob") {
              return const NativeMediumAdFlagAdmob();
            } else if (PreferenceUtils.getString(keyAdFlag) == "adx") {
              return const NativeMediumAdFlagAdx();
            }
          } else if (PreferenceUtils.getString(keyAdStyleNative) == 'ALT') {
            if (Alt_Cnt_Native_Banner == 2) {
              Alt_Cnt_Native_Banner = 1;
              return const NativeMediumAdFlagAdmob();
            } else {
              Alt_Cnt_Native_Banner++;
              return const NativeMediumAdFlagAdx();
            }
          }
        }
      }
    } else {
      return const SizedBox();
    }
  }

  static manageNative({bool isList = false}) {
    log("AD LOAD");
    if (isList) {
      if (jsonDecode(PreferenceUtils.getString(keyAdsJsonData) == "" ? {}.toString() : PreferenceUtils.getString(keyAdsJsonData))?['json_data']?['Data']?[0]?['native_type_list']
              .toString()
              .toLowerCase() ==
          "large") {
        return nativeMediumAds();
      } else if (jsonDecode(PreferenceUtils.getString(keyAdsJsonData) == "" ? {}.toString() : PreferenceUtils.getString(keyAdsJsonData))?['json_data']?['Data']?[0]
                  ?['native_type_list']
              .toString()
              .toLowerCase() ==
          "medium") {
        return nativeMediumAds();
      } else {
        return nativeBannerAds();
      }
    } else {
      if (jsonDecode(PreferenceUtils.getString(keyAdsJsonData) == "" ? {}.toString() : PreferenceUtils.getString(keyAdsJsonData))['json_data']?['Data']?[0]?['native_type_other']
              .toString()
              .toLowerCase() ==
          "large") {
        return nativeMediumAds();
      } else if (jsonDecode(PreferenceUtils.getString(keyAdsJsonData) == "" ? {}.toString() : PreferenceUtils.getString(keyAdsJsonData))['json_data']?['Data']?[0]
                  ?['native_type_other']
              .toString()
              .toLowerCase() ==
          "medium") {
        return nativeMediumAds();
      } else {
        return nativeBannerAds();
      }
    }
  }
}
