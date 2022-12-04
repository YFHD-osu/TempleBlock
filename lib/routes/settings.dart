import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templeblock/main.dart';

class SettingsButtonController{
  late bool volume = false, vibration = false, stick = false;

  Future<int> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    volume = prefs.getBool('volume') ?? true;
    vibration = prefs.getBool('vibration') ?? true;
    stick = prefs.getBool('stick') ?? true;
    return 0 ;
  }

  void toggleVolume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(volume){
      case true:
        volume = false;
        break;

      case false:
        volume = true;
        break;
    }
    await prefs.setBool('volume', volume);

  }

  void toggleVibration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(vibration){
      case true:
        vibration = false;
        break;

      case false:
        vibration = true;
        break;
    }
    await prefs.setBool('vibration', vibration);
  }

  void toggleStick() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(stick){
      case true:
        stick = false;
        break;

      case false:
        stick = true;
        break;
    }
    await prefs.setBool('stick', stick);
  }

}

class SliderController{
  late double currentValue = 1;

  Future<int> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentValue = prefs.getDouble('autoSpeed') ?? 60.0;
    return 0;
  }

  Future<int> saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("autoSpeed", currentValue);

    return 0;
  }
}

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  SettingsButtonController settingsButtonController = SettingsButtonController();
  SliderController sliderController = SliderController();

  @override
  void initState() {
    initFunctions();
    super.initState();
  }

  void initFunctions () async{
    await settingsButtonController.init();
    await sliderController.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Stack(
                  children: [
                    const Icon(Icons.settings, size: 65),
                    const SizedBox(width: 5),
                    Container(
                      margin: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                      child: Text("設定",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 48,
                        )
                      ),
                    )
                  ],
                )
            ),
            Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.yellow.shade700, Colors.red.shade800]
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          const Icon(Icons.handshake, size: 35, color: Colors.white),
                          const SizedBox(width: 2),
                          Text("累積功德:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "GenJyuuGothic",
                            )
                          ),
                          const Spacer(),
                          Text("88888",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "GenJyuuGothic",
                            )
                          ),
                          const SizedBox(width: 10)
                      ],
                      )
                    )
                  ],
                )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 80,
                          child: Image.asset('assets/medal/silver-medal.png', fit: BoxFit.fitHeight)
                        ),
                        const SizedBox(height: 10)
                      ],
                    )
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 92,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("今日累計: 96",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 23,
                            fontFamily: "GenJyuuGothic"
                          )
                        ),
                        Text("功德無量",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 41.6,
                            fontFamily: "GenJyuuGothic"
                          )
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      settingsButtonController.toggleVolume();
                      setState(() {});
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
                    ),
                    icon: Icon(Icons.volume_up, size: (MediaQuery.of(context).size.width - 30) / 3 - 20, color: (settingsButtonController.volume) ? Theme.of(context).primaryColor : Colors.grey),
                  ),
                  IconButton(
                    onPressed: () {
                      settingsButtonController.toggleVibration();
                      setState(() {});
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder())
                    ),
                    icon: Icon(Icons.vibration, size: (MediaQuery.of(context).size.width - 30) / 3 - 20, color: (settingsButtonController.vibration) ? Theme.of(context).primaryColor : Colors.grey),
                  ),
                  IconButton(
                    onPressed: () {
                      settingsButtonController.toggleStick();
                      setState(() {});
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)))),
                    ),
                    icon: Icon(Icons.auto_fix_normal, size: (MediaQuery.of(context).size.width - 30) / 3 - 20, color: (settingsButtonController.stick) ? Theme.of(context).primaryColor : Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      const Icon(Icons.speed, size: 35),
                      Text("自動木魚速度",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                            fontFamily: "GenJyuuGothic",
                          )
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                        margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("${sliderController.currentValue.round()} BPM",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium!.color,
                            fontSize: 20
                          )
                        )
                      )
                    ],
                  ),
                  Slider(
                    value: sliderController.currentValue,
                    max: 300,
                    min: 1,
                    thumbColor: Colors.black,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.black,
                    label: sliderController.currentValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        sliderController.currentValue = value;
                      });
                    },
                    onChangeEnd: (double value) async {
                      await sliderController.saveChanges();

                    },
                  )
                ],
              )

            )
          ],
        )
      )
    );
  }
}
