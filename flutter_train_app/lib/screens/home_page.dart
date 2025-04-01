import 'package:flutter/material.dart';
import 'package:flutter_train_app/screens/seatpage.dart'; // 좌석 선택 페이지
import 'package:flutter_train_app/screens/station_list_page.dart'; // 역 선택 페이지

/// ✅ 사용되는 문자열들을 상수로 정의
/// - '출발역', '도착역' 같은 텍스트를 직접 쓰지 않고 의미 있는 이름으로 관리
/// - 유지보수나 오타 방지에도 유리
const String kInitialDeparture = '출발역';
const String kInitialArrival = '도착역';

/// ✅ 홈 페이지는 StatefulWidget
/// - 사용자가 선택한 출발역/도착역 상태가 변하므로 상태 관리 필요
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // super.key는 위젯 고유 식별용

  @override
  _HomePageState createState() => _HomePageState(); // 상태 객체 생성
}

class _HomePageState extends State<HomePage> {
  /// ✅ 사용자가 선택한 출발역과 도착역을 저장하는 변수
  /// - 상태가 바뀔 수 있으므로 `var` 또는 `String`으로 선언
  /// - 초기값은 '출발역'과 '도착역'이라는 의미 있는 텍스트
  String _departureStation = kInitialDeparture;
  String _arrivalStation = kInitialArrival;

  /// ✅ 출발역/도착역을 선택하는 함수
  /// [title] : 선택 페이지 앱바 제목 ('출발역' 또는 '도착역')
  /// [isDeparture] : true면 출발역, false면 도착역 선택
  Future<void> _selectStation({
    required String title, // 함수 호출 시 반드시 전달해야 하는 매개변수
    required bool isDeparture,
  }) async {
    // 반대편 역을 제외 목록으로 설정 (중복 방지용)
    final excludeStation = isDeparture ? _arrivalStation : _departureStation;

    // 역 선택 페이지로 이동하고 결과를 기다림 (비동기)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationListPage(
          title: title,
          excludeStation: excludeStation,
        ),
      ),
    );

    // 사용자가 정상적으로 역을 선택했을 경우만 업데이트
    if (result != null && result is String) {
      setState(() {
        if (isDeparture) {
          _departureStation = result;
        } else {
          _arrivalStation = result;
        }
      });
    }
  }

  /// ✅ 출발역과 도착역을 모두 선택했는지 확인하는 함수
  bool get _isStationSelectionComplete {
    return _departureStation != kInitialDeparture &&
        _arrivalStation != kInitialArrival;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 다크모드 대응
      appBar: AppBar(
        centerTitle: true,
        title: const Text('기차 예매'), // 상단 타이틀
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 전체 중앙 정렬
          children: [
            /// ✅ 출발역 / 도착역 선택 박스
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // 다크모드 대응 색상
                borderRadius: BorderRadius.circular(20), // 모서리 둥글게
              ),
              child: Column(
                children: [
                  const SizedBox(height: 55),

                  // ✅ 상단 라벨 (출발역 / 도착역 텍스트)
                  Row(
                    children: const [
                      Expanded(
                        child: Center(
                          child: Text(
                            '출발역',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '도착역',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ✅ 선택된 역 텍스트 (선택 가능)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectStation(
                            title: '출발역',
                            isDeparture: true,
                          ),
                          child: Center(
                            child: Text(
                              _departureStation == kInitialDeparture
                                  ? '선택'
                                  : _departureStation,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 구분선
                      Container(
                        height: 50,
                        width: 2,
                        color: Colors.grey[400],
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectStation(
                            title: '도착역',
                            isDeparture: false,
                          ),
                          child: Center(
                            child: Text(
                              _arrivalStation == kInitialArrival
                                  ? '선택'
                                  : _arrivalStation,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ✅ 좌석 선택 버튼
            GestureDetector(
              onTap: () {
                if (!_isStationSelectionComplete) {
                  // 둘 중 하나라도 선택되지 않았을 경우 경고 출력
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('출발역과 도착역을 모두 선택해주세요.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // ✅ 선택된 역 정보를 가지고 좌석 선택 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeatPage(
                      departureStation: _departureStation,
                      arrivalStation: _arrivalStation,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    '좌석 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
