import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:templeblock/routes/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'themeProvider.dart';
import 'dart:async';

ThemeProvider themeProvider = ThemeProvider();

class SettingsCache{
  late bool volumeSwitch;
  late bool vibrationSwitch;
  late bool stickSwitch;
  late double autoSpeed;

  SettingsCache(){
    updateValue();
  }

  Future<int> updateValue () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    volumeSwitch = prefs.getBool('volume') ?? true;
    vibrationSwitch = prefs.getBool('vibration') ?? true;
    stickSwitch = prefs.getBool('stick') ?? true;
    autoSpeed = prefs.getDouble("autoSpeed") ?? 60.0;
    return 0;
  }

  int convertBPM() {
    //print( (1 / (autoSpeed / 60) * 1000).round());
    return (1 / (autoSpeed / 60) * 1000).round();
  }

}

SettingsCache settingsCache = SettingsCache();

void main() {
  runApp(const MyApp());
}

Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) => const SettingsRoute(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.ease;

      var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '木魚',
      themeMode: themeProvider.themeModeController,
      theme: ThemeDatas.lightTheme,
      darkTheme: ThemeDatas.darkTheme,
      home: const HomePage(title: '木魚'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  var timer;
  void switchAuto (List<bool> options) {
    try{
      timer.cancel();
    }catch(_){}

    switch(options[1]){
      case true:
        if (settingsCache.volumeSwitch){
          AudioPlayer().play(AssetSource('hitSounds/HitSound1.wav'), mode: PlayerMode.lowLatency);
        }
        _animationController.animateTo(0.45).then((value) => _animationController.animateTo(0.5));
        timer = Timer.periodic(Duration(milliseconds: settingsCache.convertBPM()), (timer) {
          if (settingsCache.volumeSwitch) {
            AudioPlayer().play(AssetSource('hitSounds/HitSound1.wav'), mode: PlayerMode.lowLatency);
          }
          _animationController.animateTo(0.45).then((value) => _animationController.animateTo(0.5));
          }
        );
        break;
      case false:
        timer.cancel();
    }
  }

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    value: 0.5,
    vsync: this,
  );
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  List <bool> hitMode = [true, false];
  List<Widget> fruits = <Widget>[
    const Text('手尻'),
    const Text('自動')
  ];

  @override
  void initState() {
    super.initState();
    initFunctions();
  }

  initFunctions() async {
    await settingsCache.updateValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0
      ),
      body: Stack(
        children: [
          const AnimatedPositioned(
            child: Text("asdasdsad"),
            duration: Duration(seconds: 10)
          ),
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 30,
                  child: ToggleButtons(
                    // direction: vertical ? Axis.vertical : Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < hitMode.length; i++) { hitMode[i] = i == index; }
                        switchAuto(hitMode);
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Theme.of(context).primaryColor,
                    selectedColor: Theme.of(context).scaffoldBackgroundColor,
                    fillColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColor,
                    borderColor: Theme.of(context).primaryColor,
                    focusColor: Colors.redAccent.withOpacity(0),
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                      minWidth: 50.0,
                    ),
                    isSelected: hitMode,
                    children: fruits,
                  ),
                )
              ),
              const Spacer(),
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0, 4, 10, 0),
                child: IconButton(
                  onPressed: () {
                    try { timer.cancel(); } catch (_){}
                    Navigator.of(context).push(_createRoute()).then((value) async {
                      await settingsCache.updateValue();
                      switchAuto(hitMode);
                    });
                  },
                  icon: const Icon(Icons.settings),
                )
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTapDown: (details) async {
                if (settingsCache.volumeSwitch) AudioPlayer().play(AssetSource('hitSounds/HitSound1.wav'), mode: PlayerMode.lowLatency);
                _animationController.animateTo(0.45);
              },
              onTapUp: (details) {
                _animationController.animateTo(0.5);
              },

              child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/tampleBlocks/TampleBlock0.png',
                    fit: BoxFit.fitWidth,
                    scale: 0.5,
                  )
              ),
            ),
          )
        ],
      )
    );
  }
}
