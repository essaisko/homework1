import 'package:flutter/material.dart';
import 'package:flutter_train_app/screens/home_page.dart'; // ✅ 앱 첫 화면 (출발/도착역 선택 화면)

/// ✅ 앱의 시작점: Flutter는 반드시 main() 함수에서 시작됨
void main() {
  runApp(const MyApp()); // 앱 실행: 최상단 위젯(MyApp)을 루트로 시작
}

/// ✅ MyApp: 앱 전체를 감싸는 루트 위젯
/// - StatelessWidget: 내부 상태가 없는 고정 구조 UI
/// - 테마, 라우팅, 첫 화면 등을 정의
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ✅ 앱 이름 (iOS 앱 스위처나 Android 최근 앱 화면 등에서 표시됨)
      title: '기차 예매',

      // ✅ 기본 밝은 테마 (라이트 모드)
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[200], // 전체 배경색
        cardColor: Colors.white, // 컨테이너 등 카드형 위젯 배경
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // 상단 앱바 배경
          foregroundColor: Colors.black, // 아이콘 및 글자색
        ),
      ),

      // ✅ 다크 테마 (사용자 기기가 다크모드일 때 적용됨)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF1E1E1E), // 어두운 카드 배경
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),

      // ✅ 실제 적용할 테마 모드 지정
      // system: 사용자의 기기 설정(light/dark)에 따라 자동 적용
      themeMode: ThemeMode.system,

      // ✅ 앱 실행 시 가장 먼저 보여줄 화면 (홈 화면)
      // HomePage는 출발역/도착역을 선택하고 좌석 페이지로 넘어가는 메인 UI
      home: const HomePage(),
    );
  }
}
