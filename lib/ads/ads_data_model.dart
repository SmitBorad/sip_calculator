class AdsDataModel {
  JsonData? jsonData;

  AdsDataModel({this.jsonData});

  AdsDataModel.fromJson(Map<String, dynamic> json) {
    jsonData = json['json_data'] != null ? new JsonData.fromJson(json['json_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jsonData != null) {
      data['json_data'] = this.jsonData!.toJson();
    }
    return data;
  }
}

class JsonData {
  List<AdsData>? data;

  JsonData({this.data});

  JsonData.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <AdsData>[];
      json['Data'].forEach((v) {
        data!.add(new AdsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdsData {
  String? admobSplash;
  String? admobSplashOpen;
  String? admobFull1;
  String? admobBanner1;
  String? admobNative1;
  String? admobReward;
  String? fbFull;
  String? fbBanner;
  String? fbNative;
  String? backclick;
  String? clickflag;
  String? click;
  String? backflag;
  String? nativeTypeList;
  String? nativeTypeOther;
  String? adflag;
  String? reward;
  String? backReward;
  String? adstyle;
  String? nativecount;
  String? backclickadstyle;
  String? adstyleNative;
  String? adstyleBanner;
  String? adtime;
  String? splash;
  String? adstatus;
  String? open;
  String? appStatus;
  String? appName;
  String? appImage;
  String? appLink;
  String? pp;
  String? native;
  String? banner;
  String? full;
  String? medium;
  String? adbtclr;
  String? backcolor;
  String? textcolor;
  String? privacyPolicy;

  AdsData(
      {this.admobSplash,
      this.admobSplashOpen,
      this.admobFull1,
      this.admobBanner1,
      this.admobNative1,
      this.fbFull,
      this.fbBanner,
      this.fbNative,
      this.backclick,
      this.clickflag,
      this.click,
      this.backflag,
      this.nativeTypeList,
      this.nativeTypeOther,
      this.adflag,
      this.adstyle,
      this.nativecount,
      this.backclickadstyle,
      this.adstyleNative,
      this.adstyleBanner,
      this.adtime,
      this.splash,
      this.adstatus,
      this.open,
      this.appStatus,
      this.appName,
      this.appImage,
      this.appLink,
      this.pp,
      this.native,
      this.banner,
      this.full,
      this.medium,
      this.adbtclr,
      this.backcolor,
      this.textcolor,
      this.privacyPolicy});

  AdsData.fromJson(Map<String, dynamic> json) {
    admobSplash = json['admob-splash'];
    admobSplashOpen = json['admob-splash-open'];
    admobFull1 = json['admob-full'];
    admobBanner1 = json['admob-banner'];
    admobNative1 = json['admob-native'];
    admobReward = json['admob-reward'];
    fbFull = json['fb-full'];
    fbBanner = json['fb-banner'];
    fbNative = json['fb-native'];
    backclick = json['backclick'];
    clickflag = json['clickflag'];
    click = json['click'];
    backflag = json['backflag'];
    nativeTypeList = json['native_type_list'];
    nativeTypeOther = json['native_type_other'];
    adflag = json['Adflag'];
    reward = json['reward'];
    backReward = json['backReward'];
    adstyle = json['Adstyle'];
    nativecount = json['nativecount'];
    backclickadstyle = json['backclickadstyle'];
    adstyleNative = json['AdstyleNative'];
    adstyleBanner = json['AdstyleBanner'];
    adtime = json['Adtime'];
    splash = json['splash'];
    adstatus = json['Adstatus'];
    open = json['open'];
    appStatus = json['app_status'];
    appName = json['app_name'];
    appImage = json['app_image'];
    appLink = json['app_link'];
    pp = json['pp'];
    native = json['native'];
    banner = json['banner'];
    full = json['full'];
    medium = json['medium'];
    adbtclr = json['adbtclr'];
    backcolor = json['backcolor'];
    textcolor = json['textcolor'];
    privacyPolicy = json['pp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admob-splash'] = this.admobSplash;
    data['admob-splash-open'] = this.admobSplashOpen;
    data['admob-full'] = this.admobFull1;
    data['admob-banner'] = this.admobBanner1;
    data['admob-native'] = this.admobNative1;
    data['admob-reward'] = this.admobReward;
    data['fb-full'] = this.fbFull;
    data['fb-banner'] = this.fbBanner;
    data['fb-native'] = this.fbNative;
    data['backclick'] = this.backclick;
    data['clickflag'] = this.clickflag;
    data['click'] = this.click;
    data['backflag'] = this.backflag;
    data['native_type_list'] = this.nativeTypeList;
    data['native_type_other'] = this.nativeTypeOther;
    data['Adflag'] = this.adflag;
    data['reward'] = this.reward;
    data['backReward'] = this.backReward;
    data['Adstyle'] = this.adstyle;
    data['nativecount'] = this.nativecount;
    data['backclickadstyle'] = this.backclickadstyle;
    data['AdstyleNative'] = this.adstyleNative;
    data['AdstyleBanner'] = this.adstyleBanner;
    data['Adtime'] = this.adtime;
    data['splash'] = this.splash;
    data['Adstatus'] = this.adstatus;
    data['open'] = this.open;
    data['app_status'] = this.appStatus;
    data['app_name'] = this.appName;
    data['app_image'] = this.appImage;
    data['app_link'] = this.appLink;
    data['pp'] = this.pp;
    data['native'] = this.native;
    data['banner'] = this.banner;
    data['full'] = this.full;
    data['medium'] = this.medium;
    data['adbtclr'] = this.adbtclr;
    data['backcolor'] = this.backcolor;
    data['textcolor'] = this.textcolor;
    data['pp'] = this.privacyPolicy;
    return data;
  }
}
