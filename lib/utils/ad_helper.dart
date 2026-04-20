import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  InterstitialAd? _interstitialAd;
  String testId = "ca-app-pub-3940256099942544/1033173712";
  String releaseId = "ca-app-pub-2813903809849367~1794780662";

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: getAdId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void showAdIfAvailable(Function onAdClosed) {
    if (_interstitialAd == null) {
      onAdClosed();
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd();
        onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        onAdClosed();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  String getAdId(){
    if(kReleaseMode){
      return releaseId;
    }
    else{
      return testId;
    }
  }
}
