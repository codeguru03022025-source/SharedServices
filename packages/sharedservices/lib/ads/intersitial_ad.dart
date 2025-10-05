import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  final String adUnitId;
  InterstitialAdManager({required this.adUnitId});


  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  void loadAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          debugPrint("Interstitial ad loaded");
        },
        onAdFailedToLoad: (error) {
          debugPrint("Failed to load interstitial: $error");
        },
      ),
    );
  }

  void showAd({
    VoidCallback? onAdShown,
    VoidCallback? onAdDismissed,
    Function(AdError)? onAdFailedToShow,
    VoidCallback? onAdClicked,
  }) {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          onAdShown?.call();
          debugPrint("Interstitial ad shown");
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isAdLoaded = false;
          onAdDismissed?.call();
          debugPrint("Interstitial ad dismissed");
          loadAd(); // preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isAdLoaded = false;
          onAdFailedToShow?.call(error);
          debugPrint("Interstitial ad failed to show: $error");
        },
        onAdImpression: (ad) {
          debugPrint("Interstitial ad impression recorded");
        },
        onAdClicked: (ad) {
          onAdClicked?.call();
          debugPrint("Interstitial ad clicked");
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint("Interstitial ad not loaded yet.");
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }


}
