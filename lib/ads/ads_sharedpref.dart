import 'package:shared_preferences/shared_preferences.dart';

///Ads
String keyAdsJsonData = "adsJsonData";
String keyAdmobSplash = "admobSplash";
String keyAdmobFull = "admob-full";
String keyAdmobBanner = "admobBanner";
String keyAdmobOpen = "admobOpen";
String keyAdmobNative = "admobNative";
String keyAdmobReward = "admobReward";
String keyFbFull = "appFbFull";
String keyFbBanner = "appFbBanner";
String keyFbNative = "appFbNative";
String keyClick = "click";
String keyBackClick = "backClick";
String keyClickFlag = "clickFlag";
String keyBackFlag = "backFlag";
String keyAdFlag = "adFlag";
String keyAdReward = "keyAdReward";
String keyAdBackReward = "keyAdBackReward";
String keyAdStyle = "adStyle";
String keyAdStatus = "adStatus";
String keyAdTime = "adTime";
String keyBackClickAdStyle = "backClickAdStyle";
String keyAdStyleNative = "adStyleNative";
String keyAdStyleBanner = "AdStyleBanner";
String keyNativeOn = "nativeOn";
String keyBannerOn = "bannerOn";
String keyFullOn = "fullOn";
String keyTapTime = 'keyTapTime';
String privacyPolicy = 'privacyPolicy';
String qureka = 'qureka';
String qurekaUrl = 'qurekaUrl';
String qurekaRedirectIs = 'qurekaRedirect';
String qurekaRedirectShort = 'qurekaRedirectShort';
String qurekaInter = 'qurekaInter';
String lanCode = 'lanCode';
String skipIntro = 'skipIntro';
String isFirstUser = 'isFirstUser';
String isAdLoadedAndShown = 'isAdLoadedAndShown';
String nativeAdPre = 'nativeAdPre';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;
// call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getString(key) ?? "") : "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return _prefsInstance != null ? prefs.setString(key, value) : Future.value(false);
  }

  static bool getBool(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getBool(key) ?? false) : false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return _prefsInstance != null ? prefs.setBool(key, value) : Future.value(false);
  }
}
