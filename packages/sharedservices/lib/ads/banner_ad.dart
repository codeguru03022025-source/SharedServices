import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  bool isTab;
  BannerAdWidget({super.key, required this.adUnitId, required this.isTab});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with TickerProviderStateMixin {
  late BannerAd _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Failed to load banner ad: $error');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn, // replaced FlippedCurve with valid curve
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isLoaded ? 1 : 0,
        child: Container(
          color: Colors.grey,
          height: widget.isTab ? 70 : 50,
          width: double.infinity,
          // height: _bannerAd.size.height.toDouble(),
          // width: _bannerAd.size.width.toDouble(),
          child: AdWidget(ad: _bannerAd),
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
