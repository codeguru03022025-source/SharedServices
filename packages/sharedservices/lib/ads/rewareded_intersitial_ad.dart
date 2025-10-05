import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedInterstitialAdManager {
  final String adUnitId;
  RewardedInterstitialAdManager({required this.adUnitId});

  RewardedInterstitialAd? _rewardedAd;
  bool _isAdLoaded = false;

  Future<bool> loadAd() async {
    final completer = Completer<bool>();
    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          debugPrint("Rewarded interstitial ad loaded");
          completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint("Failed to load rewarded interstitial: $error");
          completer.complete(false);
        },
      ),
    );
    return completer.future;
  }


  Future<void> showAd({
    required VoidCallback onRewardEarned,
    VoidCallback? onAdShown,
    VoidCallback? onAdDismissed,
    Function(AdError)? onAdFailedToShow,
    VoidCallback? onAdClicked,
    VoidCallback? onCancelled,
  }) async {
    if (_isAdLoaded && _rewardedAd != null) {
      bool _rewardGiven = false;

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          onAdShown?.call();
          debugPrint("Rewarded interstitial ad shown");
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isAdLoaded = false;
          if (_rewardGiven) {
            onAdDismissed?.call();
          } else {
            onCancelled?.call(); // Treat dismissed without reward as "cancel"
          }
          debugPrint("Rewarded interstitial ad dismissed");
          loadAd(); // Preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isAdLoaded = false;
          onAdFailedToShow?.call(error);
          debugPrint("Failed to show rewarded interstitial: $error");
        },
        onAdClicked: (ad) {
          onAdClicked?.call();
          debugPrint("Rewarded ad clicked");
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          _rewardGiven = true;
          onRewardEarned();
          debugPrint('Reward earned: ${reward.amount} ${reward.type}');
        },
      );

      _rewardedAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint("Rewarded interstitial ad not loaded yet.");
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
