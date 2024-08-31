import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobFacebookBannerAd extends StatefulWidget {
  const AdmobFacebookBannerAd({Key? key}) : super(key: key);

  @override
  State<AdmobFacebookBannerAd> createState() => _AdmobFacebookBannerAdState();
}

class _AdmobFacebookBannerAdState extends State<AdmobFacebookBannerAd> {
  var admobAdId = PreferenceUtils.getString(keyAdmobBanner);
  var facebookAdId = PreferenceUtils.getString(keyFbBanner);
  BannerAd? anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  bool _showQreka = false;
  bool showFacebookAd = false;
  @override
  void dispose() {
    anchoredAdaptiveAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    loadBannerAd();
  }

  Future<void> loadBannerAd() async {
    await anchoredAdaptiveAd?.dispose();
    setState(() {
      anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    anchoredAdaptiveAd = BannerAd(
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',

      adUnitId: admobAdId,
      // adUnitId: PreferenceUtils.getString(keyAdmobBanner),
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('ajsfkewr===${error.message}');
          setState(() {
            showFacebookAd = true;
          });
        },
      ),
    )..load();
    return anchoredAdaptiveAd!.load();
  }

  Widget getBannerAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation && anchoredAdaptiveAd != null && _isLoaded) {
          return Container(width: anchoredAdaptiveAd!.size.width.toDouble(), height: anchoredAdaptiveAd!.size.height.toDouble(), child: AdWidget(ad: anchoredAdaptiveAd!));
        } else if (showFacebookAd) {
          return FacebookBannerAd(
            placementId: facebookAdId, //testid
            bannerSize: BannerSize.STANDARD,
            listener: (result, value) {
              if (result == BannerAdResult.ERROR) {}
            },
          );
        }

        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          loadBannerAd();
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) => getBannerAdWidget();
}
