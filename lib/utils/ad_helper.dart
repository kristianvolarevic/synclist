import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  InterstitialAd? _interstitialAd;
  // Interstitial Ad IDs
  String interstitialTestId = "ca-app-pub-3940256099942544/1033173712";
  String interstitialReleaseId = "ca-app-pub-2813903809849367/8049197820";

  // Banner Ad IDs
  String bannerTestId = "ca-app-pub-3940256099942544/6300978111";
  String bannerReleaseId = "ca-app-pub-2813903809849367/2373413866";

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: getAdId(isBanner: false),
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

  BannerAd loadBannerAd({
    required VoidCallback onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: getAdId(isBanner: true),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(error);
        },
      ),
      request: const AdRequest(),
    )..load();
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

  String getAdId({required bool isBanner}) {
    if (kReleaseMode) {
      return isBanner ? bannerReleaseId : interstitialReleaseId;
    } else {
      return isBanner ? bannerTestId : interstitialTestId;
    }
  }
}
