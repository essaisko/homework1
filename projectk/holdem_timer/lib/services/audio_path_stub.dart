import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // ✅ 요거 추가!

String getWebCompatibleAudioPath() {
  if (!kIsWeb) return 'sounds/blind_change.mp3';

  try {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    final isSafari =
        userAgent.contains('safari') && !userAgent.contains('chrome');

    return isSafari
        ? 'sounds/blind_change.mp3' // ✅ Safari는 mp3만 지원
        : 'sounds/blind_change.ogg'; // ✅ 그 외엔 ogg
  } catch (e) {
    return 'sounds/blind_change.mp3'; // fallback
  }
}
