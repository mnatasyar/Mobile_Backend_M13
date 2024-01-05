import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  int coin = 0;
  late BannerAd _bannerAd;
  bool _isBannerReady = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialReady = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedReady = false;

  bool _isAdDisabled = false;
  int _disableAdsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadinterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admob"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 50,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    coin.toString(),
                    style: TextStyle(fontSize: 50),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _showInterstitialAd();
                },
                child: Text("Interstitial ads™"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _loadRewardedAd();
                  if (_isRewardedReady) {
                    _showRewardedAd();
                  }
                },
                child: Text("Rewarded ads"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _disableAds();
                },
                child: Text("Stop Iklan"),
              ),
            ),
            Expanded(
              child: _isBannerReady && !_isAdDisabled
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerReady = false;
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );
    _bannerAd.load();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _isRewardedReady = true;
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          _isRewardedReady = false;
          _rewardedAd.dispose();
        },
      ),
    );
  }

  void _loadinterstitialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _isInterstitialReady = true;
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          _isInterstitialReady = false;
          _interstitialAd.dispose();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (!_isAdDisabled && _isInterstitialReady) {
      _interstitialAd.show();
    } else {
      print("Iklan dinonaktifkan atau tidak siap.");
    }
  }

  void _showRewardedAd() {
    if (!_isAdDisabled && _isRewardedReady) {
      _rewardedAd.show(onUserEarnedReward: (Ad ad, RewardItem reward) {
        setState(() {
          coin += 1;
        });
      });
    } else {
      print("Iklan dinonaktifkan atau tidak siap.");
    }
  }

  void _disableAds() {
    setState(() {
      if (_disableAdsCount < 2) {
        _isAdDisabled = true;
      } else {
        _isAdDisabled = false;
        _disableAdsCount = 0;
      }
      _disableAdsCount++;
    });
  }
}
