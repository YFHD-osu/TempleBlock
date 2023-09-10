# Flutter Temple Block

 ***<p style="text-align: center;">《Karma never waits》 </p>***
 百因必有果，但如果來不及了，就來敲木魚亡羊補牢

## 素材

| 木魚音效       | 罄的聲音        |
| ------------- |:-------------:|
| [Youtube](https://youtu.be/umqA5IMx_2I) | [Youtube](https://youtu.be/21O9qxKO1XA) |
| [Youtube](https://youtu.be/hChhFUuED6k) | [Youtube](https://youtu.be/i8r1NGHPwwo) |
| [Youtube](https://youtu.be/hChhFUuED6k?si=VV9b7tqbKKWEs1nJ) | |
| 拿螢光筆敲筆蓋 |  |

## 功能
- [X] 敲木魚積陰德
- [ ] 顯示目前陰德量
- [ ] 用帳號儲存功德值
- [ ] 暗/亮色模式
- [ ] 功德等級
- [ ] 功德榜（全用戶排名）
- [ ] 敲擊棒的開關
- [ ] 即時CPS偵測
- [ ] 每敲幾次發出 ”叮” 音效
- [x] 調整自動木魚的速度

## 功德等級
- 居士
- 沙彌
- 比丘
- 羅漢
- 菩薩
- 如來
- 彌勒

## 目標
- 接上Firebase，建立登入系統
- 使用[sqflite](https://pub.dev/packages/sqflite)存放本地資料
- 使用[vibration](https://pub.dev/packages/vibration)、[flutter_haptic](https://pub.dev/packages/flutter_haptic)、[HapticFeedback](https://api.flutter.dev/flutter/services/HapticFeedback-class.html)在敲擊時震動
