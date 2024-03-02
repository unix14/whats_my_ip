import 'package:dart_ipify/dart_ipify.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whats_my_ip/ad_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyIPApp());
}

class MyIPApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s My IP?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(background: Colors.black),
        fontFamily: 'Preahvihear',
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'What\'s My IP?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentIp = "N/A";
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    _calculateIp();
    if(kReleaseMode) {
      loadAd();
    }
    super.initState();
  }

  _calculateIp() async {
    var ipv4 = await Ipify.ipv64();
    setState(() {
      currentIp = ipv4;
    });
  }

  @override
  Widget build(BuildContext context) {
    //todo add wifi\4g distinction icon
    //todo add ipv4\v6 distinction
    //todo add simple interactions with Black Launcher app
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        actions: const [
          //todo add settings with simple attributions to dev
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Spacer(),
            Text(
              'Your IP address is:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              currentIp,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: IconButton.outlined(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: currentIp));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("IP was copied"),
                  ));
                },
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.copy),
                ),
              ),
            ),
            const Spacer(),
            _bannerAd != null && _isLoaded ? Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
}