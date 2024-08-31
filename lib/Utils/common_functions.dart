import 'package:flutter_sip_calculator/ads/ads_sharedpref.dart';
import 'package:url_launcher/url_launcher.dart';

qurekaRedirect() async {
  if (PreferenceUtils.getString(qurekaRedirectIs).toString() == 'on') {
    if (await canLaunchUrl(Uri.parse(PreferenceUtils.getString(qurekaUrl)))) {
      try {
        await launchUrl(Uri.parse(PreferenceUtils.getString(qurekaUrl)));
      } catch (e) {}
    }
  } else {}
}
