import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_data_model.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';

class FirebaseRemoteConfigKeys {
  static const String adsData = 'sip_cal';
}

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._() : _remoteConfig = FirebaseRemoteConfig.instance; // MODIFIED

  static FirebaseRemoteConfigService? _instance; // NEW
  factory FirebaseRemoteConfigService() => _instance ??= FirebaseRemoteConfigService._(); // NEW

  final FirebaseRemoteConfig _remoteConfig;

  String getString(String key) => _remoteConfig.getString(key);

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
    await setDataInStorage();
  }

  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      debugPrint('The config has been updated.');
    } else {
      debugPrint('The config is not updated..');
    }
  }

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 10),
        ),
      );

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
        const {
          FirebaseRemoteConfigKeys.adsData: '',
        },
      );

  setDataInStorage() async {
    log('ahtsejdr===${_remoteConfig.getString(FirebaseRemoteConfigKeys.adsData)}');
    String adsData = _remoteConfig.getString(FirebaseRemoteConfigKeys.adsData);
    if (adsData.isNotEmpty) {
      Map<String, dynamic> stringToMap = json.decode(adsData);
      await PreferenceUtils.setString(keyAdsJsonData, adsData);
      AdsDataModel dataModel = AdsDataModel.fromJson(stringToMap);
      if ((dataModel.jsonData?.data ?? []).isNotEmpty) {
        AdsData adsDataModel = dataModel.jsonData?.data?[0] ?? AdsData();
        await PreferenceUtils.setString(qureka, jsonDecode(adsData)['json_data']?['Data']?[0]?['qureka']);
        await PreferenceUtils.setString(nativeAdPre, jsonDecode(adsData)['json_data']?['Data']?[0]?['NativeLoad']);
        await PreferenceUtils.setString(skipIntro, (jsonDecode(adsData)['json_data']?['Data']?[0]?['skip_intro']).toString());
        await PreferenceUtils.setString(qurekaUrl, jsonDecode(adsData)['json_data']?['Data']?[0]?['qureka-link']);
        await PreferenceUtils.setString(qurekaRedirectIs, jsonDecode(adsData)['json_data']?['Data']?[0]?['direct_link']);
        await PreferenceUtils.setString(qurekaRedirectShort, jsonDecode(adsData)['json_data']?['Data']?[0]?['short_cut']);
        await PreferenceUtils.setString(qurekaInter, jsonDecode(adsData)['json_data']?['Data']?[0]?['qureka-inter']);
        await PreferenceUtils.setString(keyAdmobSplash, adsDataModel.admobSplash ?? '');
        await PreferenceUtils.setString(keyAdmobSplash, adsDataModel.admobSplash ?? '');
        await PreferenceUtils.setString(keyAdFlag, adsDataModel.adflag ?? '');
        await PreferenceUtils.setString(keyAdStatus, adsDataModel.adstatus ?? '');
        await PreferenceUtils.setString(keyAdReward, adsDataModel.reward ?? '');
        await PreferenceUtils.setString(keyAdBackReward, adsDataModel.backReward ?? '');
        await PreferenceUtils.setString(keyAdStyle, adsDataModel.adstyle ?? '');
        await PreferenceUtils.setString(keyFbFull, adsDataModel.fbFull ?? '');
        await PreferenceUtils.setString(keyBannerOn, adsDataModel.banner ?? '');
        await PreferenceUtils.setString(keyAdStyleBanner, adsDataModel.adstyleBanner ?? '');
        await PreferenceUtils.setString(keyAdmobBanner, adsDataModel.admobBanner1 ?? '');
        await PreferenceUtils.setString(keyFbBanner, adsDataModel.fbBanner ?? '');
        await PreferenceUtils.setString(keyAdmobNative, adsDataModel.admobNative1 ?? '');
        await PreferenceUtils.setString(keyAdmobReward, adsDataModel.admobReward ?? '');
        await PreferenceUtils.setString(keyFbNative, adsDataModel.fbNative ?? '');
        await PreferenceUtils.setString(keyNativeOn, adsDataModel.native ?? '');
        await PreferenceUtils.setString(keyAdStyleNative, adsDataModel.adstyleNative ?? '');
        await PreferenceUtils.setString(keyAdmobFull, adsDataModel.admobFull1 ?? '');
        await PreferenceUtils.setString(keyClick, adsDataModel.click ?? '');
        await PreferenceUtils.setString(keyBackFlag, adsDataModel.backflag ?? '');
        await PreferenceUtils.setString(keyBackClickAdStyle, adsDataModel.backclickadstyle ?? '');
        await PreferenceUtils.setString(keyBackClick, adsDataModel.backclick ?? '');
        await PreferenceUtils.setString(keyAdTime, adsDataModel.adtime ?? '');
        await PreferenceUtils.setString(keyClickFlag, adsDataModel.clickflag ?? '');
        await PreferenceUtils.setString(privacyPolicy, adsDataModel.privacyPolicy ?? '');
        /* await PreferenceUtils.setString(
          admobSplash,
        );*/

        print('sdjfsldf===${dataModel.jsonData?.data?[0].admobBanner1}');
      }
    }
  }
}

///dummy data
var demoData = {
  "json_data": {
    "Data": [
      {
        "account": "Demo",
        "admob-splash-open": "ca-app-pub-3940256099942544/3419835294",
        "admob-splash": "ca-app-pub-3940256099942544/1033173712",
        "admob-full": "ca-app-pub-3940256099942544/1033173712",
        "admob-banner": "ca-app-pub-3940256099942544/6300978111",
        "admob-native": "ca-app-pub-3940256099942544/2247696110",
        "fb-full": "637032235021849_637042295020843",
        "fb-banner": "637032235021849_637042561687483",
        "fb-native": "637032235021849_637042478354158",
        "qureka": "predchamp",
        "qureka-link": "https://55.play.online.thopgames.com",
        "direct_link": "off",
        "url_for_ads": "https://55.play.online.thopgames.com",
        "click": "3",
        "backclick": "1",
        "clickflag": "on",
        "backflag": "on",
        "native_type_list": "large",
        "native_type_other": "large",
        "Adflag": "adx",
        "AdstyleNative": "normal",
        "AdstyleBanner": "normal",
        "Adstyle": "normal",
        "Adtime": "40",
        "splash": "open",
        "Adstatus": "on",
        "app_status": "on",
        "app_name": "NewApp",
        "app_image": "https:/abc",
        "app_link": "https://abc.ci",
        "pp": "https://sites.google.com/view/apps-privacypolicy/home",
        "native": "on",
        "banner": "on",
        "full": "on",
        "open": "on",
        "adbtclr": "1196ff",
        "backcolor": "ffffff",
        "textcolor": "000000"
      }
    ]
  }
};
