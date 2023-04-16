import 'package:templeblock/routes/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'themeProvider.dart';
import 'dart:async';

ThemeProvider themeProvider = ThemeProvider();
SettingsCache settingsCache = SettingsCache();

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

class TempleBlock {
  Timer autoTimer = Timer.periodic(const Duration(hours: 999),(timer) {}); //這裡的函數只是個噱頭
  late final AnimationController stickAnimationController;
  late final AnimationController blockAnimationController;
  TempleBlock(this.stickAnimationController, this.blockAnimationController);

  void hit(){
    if (settingsCache.volumeSwitch) AudioPlayer().play(AssetSource('hitSounds/HitSound1.wav'), mode: PlayerMode.lowLatency);
    blockAnimationController.animateTo(0.45);
    stickAnimationController.animateTo(0.25);
  }

  void release(){
    blockAnimationController.animateTo(0.5);
    stickAnimationController.animateTo(0.21);
  }

  void loopSound(timer){
    if (settingsCache.volumeSwitch)
    {AudioPlayer().play(AssetSource('hitSounds/HitSound1.wav'), mode: PlayerMode.lowLatency); }
    blockAnimationController.animateTo(0.45).then((value) => blockAnimationController.animateTo(0.5));
    stickAnimationController.animateTo(0.25).then((value) => stickAnimationController.animateTo(0.21));
  }

  void stopSound (){
    if (autoTimer.isActive) autoTimer.cancel();
  }

  void switchMode (List<bool> options) {
    switch(options[1]){
      case true:
        loopSound(0);
        if (autoTimer.isActive) autoTimer.cancel();
        autoTimer = Timer.periodic(Duration(milliseconds: settingsCache.convertBPM()), loopSound);
        break;
      case false:
        autoTimer.cancel();
    }
  }

}

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
  late final Animation<double> blockScaleAnimation;
  late final AnimationController blockAnimationController;
  late final Animation<double> stickRotateAnimation;
  late final AnimationController stickAnimationController;
  late final TempleBlock templeBlock;

  List <bool> hitMode = [true, false];
  List<Widget> fruits = <Widget>[ const Text('手尻'), const Text('自動') ];

  @override
  void initState() {
    super.initState();
    // Temple Block Scale Animation
    blockAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      value: 0.5,
      vsync: this
    );
    blockScaleAnimation = CurvedAnimation(
      parent: blockAnimationController,
      curve: Curves.fastOutSlowIn
    );

    // Stick rotatye Animation
    stickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      value: 0.21,
      vsync: this
    );
    stickRotateAnimation = CurvedAnimation(
      parent: stickAnimationController,
      curve: Curves.fastOutSlowIn
    );
    initAsync(); // 執行非同步的初始化
    templeBlock = TempleBlock(stickAnimationController, blockAnimationController); // 套用到木魚 Class
  }

  initAsync() async {
    await settingsCache.updateValue();
  }

  @override
  void dispose() {
    super.dispose();
    blockAnimationController.dispose();
    stickAnimationController.dispose();
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
          SizedBox(
            child: Container(
              height: MediaQuery.of(context).size.height,
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width, maxWidth: MediaQuery.of(context).size.width),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ScaleTransition(
                  scale: blockScaleAnimation,
                  child: Image.asset(
                    'assets/tampleBlocks/TampleBlock0.png',
                    fit: BoxFit.fitWidth,
                    scale: 0.5,
                  )
                ),
            )
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 150, 0, 0),
            height: 250,
            child: RotationTransition(
              turns: stickRotateAnimation,
              child: Image.asset(
                'assets/stick/hotdog-stick.png',
                fit: BoxFit.fitWidth,
                scale: 0.5,
              ),
            )
          ),
          InkWell(
            onTapDown: (details) => templeBlock.hit(),
            onTapCancel: () => templeBlock.release(),
            onTapUp: (details) => templeBlock.release(),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          const AnimatedPositioned(
            duration: Duration(seconds: 10),
            child: Text("Test")
          ),
          Row( //最上面那條功能列
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
                        templeBlock.switchMode(hitMode);
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
                    templeBlock.stopSound();
                    Navigator.of(context).push(_createRoute()).then((value) async {
                      await settingsCache.updateValue();
                      templeBlock.switchMode(hitMode);
                    });
                  },
                  icon: const Icon(Icons.settings),
                )
              )
            ],
          ),
        ],
      )
    );
  }
}
