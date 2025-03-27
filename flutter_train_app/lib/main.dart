import 'package:flutter/material.dart';
import 'package:flutter_train_app/screens/home_page.dart'; // ✅ 앱의 첫 화면(HomePage)을 불러오는 import

void main() {
  // ✅ 앱 실행 진입점: runApp()은 위젯 트리를 최상단에서부터 시작하도록 함
  runApp(const MyApp());
}

/// 앱의 루트 위젯 (StatelessWidget)
/// 전체 앱의 테마와 초기화된 화면을 정의함
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ✅ 앱의 이름 (iOS 앱 스위처 등에서 보임)
      title: '기차 예매',

      // ✅ 기본 밝은 테마 설정
      theme: ThemeData(
        brightness: Brightness.light, // 기본 밝기: light
        scaffoldBackgroundColor: Colors.grey[200], // Scaffold 전체 배경색
        cardColor: Colors.white, // 컨테이너, 카드 등 기본 배경 색상
        appBarTheme: const AppBarTheme(
          // 앱 상단 바 테마
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // 아이콘, 텍스트 색상
        ),
      ),

      // ✅ 다크 테마 설정 (사용자 시스템이 다크모드일 때 적용됨)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Scaffold 배경을 어둡게
        cardColor: Color(0xFF1E1E1E), // 카드 및 컨테이너 배경을 어둡게
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),

      // ✅ 실제 사용할 테마 모드: 시스템 설정에 따름
      // system → 사용자의 디바이스가 다크모드인지 아닌지 따라감
      themeMode: ThemeMode.system,

      // ✅ 앱 시작 시 가장 먼저 보여줄 화면 지정 (홈화면)
      // HomePage는 사용자에게 출발역/도착역을 선택하게 하고, 좌석 선택 페이지로 이동함
      home: const HomePage(),
    );
  }
}
