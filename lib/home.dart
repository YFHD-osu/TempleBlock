import 'dart:async';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:animated_digit/animated_digit.dart';

import 'package:templeblock/database.dart';
import 'package:templeblock/settings.dart';

class TempleBlock {
  final TickerProvider tick;
  final player = AudioPlayer();
  final source = AssetSource('hitSounds/HitSound1.wav');
  bool isPlaying = false;

  late final AnimationController stickController = AnimationController(
    duration: const Duration(milliseconds: 500), value: 0.21, vsync: tick
  );
  late final AnimationController blockController = AnimationController(
    duration: const Duration(milliseconds: 500), value: 0.5, vsync: tick
  );

  TempleBlock({required this.tick});
  
  Timer autoTimer = Timer.periodic(const Duration(hours: 999),(timer) {}); //這裡的函數只是個噱頭

  Future<void> hit() async {
    print(isPlaying);
    if (Settings.instance.volume && !isPlaying)  {
      isPlaying = true;
      player.play(source, mode: PlayerMode.lowLatency);
      Future.delayed(const Duration(milliseconds: 500)).then((value) => isPlaying = false);
    }
    Settings.instance.hitCount.value++;
    final task1 = blockController.animateTo(0.45);
    final task2 = stickController.animateTo(0.25);
    await Future.wait([task1, task2]);
  }

  void release() {
    blockController.animateTo(0.5);
    stickController.animateTo(0.21);
  }

  void loopSound(timer) async {
    if (Settings.instance.volume) {
      player.play(source, mode: PlayerMode.mediaPlayer);
    }
    await hit();
    release();
  }

  void stopSound() {
    if (autoTimer.isActive) autoTimer.cancel();
  }

  void switchMode(List<bool> options) {
    switch(options[1]){
      case true:
        loopSound(0);
        if (autoTimer.isActive) autoTimer.cancel();
        autoTimer = Timer.periodic(Duration(milliseconds: Settings.instance.convertBPM()), loopSound);
        break;
      case false:
        autoTimer.cancel();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final controller = TempleBlock(tick: this);

  List<Widget> textList = [];
  List<bool> hitMode = [true, false];
  List<Widget> fruits = <Widget>[ const Text('手尻'), const Text('自動') ];

  Future<void> _popText() async {
    final cId = Settings.instance.hitCount.value;
    final textWidget = PopText(key: ValueKey<int>(cId));
    textList.add(textWidget);
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    textList.remove(textWidget);
    setState(() {});
  }

  @override
  void initState() {
    Settings.instance.hitCount.addListener(_popText);
    super.initState();
  }

  @override
  void dispose() {
    Settings.instance.hitCount.removeListener(_popText);
    super.dispose();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) => const SettingsRoute(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.ease;
        var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  PreferredSizeWidget _appbar() => PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: AppBar(
      centerTitle: true,
      title: ListenableBuilder(
        listenable: Settings.instance.hitCount,
        builder:(context, child) => AnimatedDigitWidget(
          value: Settings.instance.hitCount.value,
          textStyle: const TextStyle(fontSize: 30, color:  Colors.white),
        )
      ),
      leading: Center(
        child: Text(' 功德木魚', style: Theme.of(context).textTheme.titleLarge)
      ),
      leadingWidth: 100,
      actions: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            height: 50,
            child: ToggleButtons(
              // direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < hitMode.length; i++) { hitMode[i] = i == index; }
                  controller.switchMode(hitMode);
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
        IconButton(
          onPressed: () {
            controller.stopSound();
            Navigator.of(context).push(_createRoute()).then((value) async {
              await Settings.instance.initialize();
              controller.switchMode(hitMode);
            });
          },
          icon: const Icon(Icons.settings)
        )
      ],
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ...textList,
          Center(
            child: TempleBlockPage(
              controller: controller,
            ),
          ),
          InkWell(
            onTapDown: (details) => controller.hit(),
            onTapCancel: () => controller.release(),
            onTapUp: (details) => controller.release(),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          )
        ],
      )
    );
  }
}

class TempleBlockPage extends StatefulWidget {
  const TempleBlockPage({
    super.key,
    required this.controller
  });

  final TempleBlock controller;
  @override
  State<TempleBlockPage> createState() => _TempleBlockPageState();
}

class _TempleBlockPageState extends State<TempleBlockPage> {
  late final blockAnime = CurvedAnimation(
    curve: Curves.fastOutSlowIn,
    parent: widget.controller.blockController
  );

  late final stickAnime = CurvedAnimation(
    curve: Curves.fastOutSlowIn,
    parent: widget.controller.stickController
  );

  @override
  void dispose() {
    super.dispose();
    blockAnime.dispose();
    stickAnime.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final size = (width<height) ? width : height;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        ScaleTransition(
          scale: blockAnime,
          child: Image.asset(
            'assets/tampleBlocks/TampleBlock0.png',
            fit: BoxFit.fitWidth,
            width: size / 1.2,
            height: size / 1.2
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
          child: RotationTransition(
            turns: stickAnime,
            child: Image.asset(
              'assets/stick/hotdog-stick.png',
              fit: BoxFit.fitWidth,
              height: size / 2.1
            )
          )
        )
      ]
    );
  }
}

class PopText extends StatefulWidget {
  const PopText({super.key});

  @override
  State<PopText> createState() => _PopTextState();
}

class _PopTextState extends State<PopText> with TickerProviderStateMixin{
  double opacity = 0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..animateTo(1);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 5),
    end: Offset.zero
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  Future<void> _setOpacity(double val) async {
    if (!mounted) return;
    setState(() => opacity = val);
  }

  @override
  void initState() {
    super.initState();
    _setOpacity(1)
    .then((value) => Future.delayed(const Duration(milliseconds: 500)))
    .then((value) => _setOpacity(0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 200),
        child: SlideTransition(
          position: _offsetAnimation,
          child: const Text("統測+700分",
          style: TextStyle(color: Colors.white, fontSize: 40)
          )
        )
      )
    );
  }
}