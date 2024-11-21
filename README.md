# webRTC

![dependencies](https://img.shields.io/badge/channel-stable-blue)
![dependencies](https://img.shields.io/badge/Flutter-v2.0.3-blue)
![dependencies](https://img.shields.io/badge/Dart-v2.12.2-blue)

<a href='https://pub.dev/packages/flutter_webrtc'>

![dependencies](https://img.shields.io/badge/flutter_webrtc-0.5.8-blue) </a>
<a href=https://pub.dev/packages/sdp_transform>
![dependencies](https://img.shields.io/badge/sdp_transform-v2.0.3-blue)
</a>

It's better to visit [official doc.](https://pub.dev/packages/flutter_webrtc)

`android:minSdkVersion="23" for webRTC forground service`

⚠ `Provide your own width, height and frame rate here`  
if it's larger than your screen , it wont showUP

[Breakdown of an SDP (Session Description Protocol)](https://webrtchacks.com/sdp-anatomy/)

---

## work flow

- click Offer on 1st tab
  - get token and paste on 2nd tab and press set remote desc
- click answer on 2nd tab and copy sdp

  - copy and paste on 1st then set remote description
  - click answer on 2nd tab copy and paste
  - set remote descript on 1st tab

  - next add candidate from 2nd tab
  - copy candidate from 2nd tab
  - paste on 1st tab and set as candidate
  - congo

---

---

### Checking null-safety of packages

`dart pub outdated --mode=null-safety`

---

#### helper:

- [Curves-class](https://api.flutter.dev/flutter/animation/Curves-class.html)

## License & copyright

Licensed under the [MIT License](LICENCE).

---

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
