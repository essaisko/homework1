// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

String getWebCompatibleAudioPath() {
  final userAgent = window.navigator.userAgent.toLowerCase();
  final isSafari =
      userAgent.contains('safari') && !userAgent.contains('chrome');

  return isSafari ? 'sounds/blind_change.mp3' : 'sounds/blind_change.ogg';
}
