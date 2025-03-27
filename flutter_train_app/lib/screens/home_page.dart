import 'package:flutter/material.dart';
import 'package:flutter_train_app/screens/seatpage.dart'; // 좌석 선택 페이지
import 'package:flutter_train_app/screens/station_list_page.dart'; // 출발/도착역 선택 페이지

/// 홈 화면: 사용자에게 출발역과 도착역을 선택하게 하고,
/// 모든 선택이 완료되면 좌석 선택 페이지로 이동하는 메인 UI
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ 사용자가 선택한 출발역과 도착역 저장 변수
  String _departureStation = '출발역'; // 초기값은 아직 선택되지 않음을 의미
  String _arrivalStation = '도착역';

  /// ✅ 출발역 또는 도착역을 선택하는 함수
  /// title: 앱바에 표시할 제목 (예: '출발역')
  /// isDeparture: true면 출발역을, false면 도착역을 선택하는 로직 분기
  Future<void> _selectStation({
    required String title,
    required bool isDeparture,
  }) async {
    // 다른 역이 이미 선택된 경우, 중복 방지를 위해 제외시킴
    final excludeStation = isDeparture ? _arrivalStation : _departureStation;

    // StationListPage로 이동, 선택 결과를 기다림
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationListPage(
          title: title,
          excludeStation: excludeStation,
        ),
      ),
    );

    // 역이 정상적으로 선택되었을 경우, 상태 갱신
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 다크모드 대응
      appBar: AppBar(
        centerTitle: true,
        title: const Text('기차 예매'), // 앱 상단 제목
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 전체 화면 중앙 정렬
        children: [
          /// ✅ 출발역/도착역 선택 영역
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // 다크/라이트 테마 대응
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const SizedBox(height: 55),

                // ✅ 출발역, 도착역 라벨 텍스트
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

                // ✅ 선택된 출발역/도착역 텍스트 (클릭 가능)
                Row(
                  children: [
                    // 출발역 선택
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _selectStation(title: '출발역', isDeparture: true),
                        child: Center(
                          child: Text(
                            _departureStation == '출발역'
                                ? '선택'
                                : _departureStation,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 가운데 구분선
                    Container(
                      height: 50,
                      width: 2,
                      color: Colors.grey[400],
                    ),
                    // 도착역 선택
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _selectStation(title: '도착역', isDeparture: false),
                        child: Center(
                          child: Text(
                            _arrivalStation == '도착역' ? '선택' : _arrivalStation,
                            style: const TextStyle(
                              fontSize: 30,
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

          const SizedBox(height: 20),

          /// ✅ 좌석 선택으로 이동하는 버튼
          GestureDetector(
            onTap: () {
              if (_departureStation == '출발역' || _arrivalStation == '도착역') {
                // ❗역을 선택하지 않았을 경우 경고 메시지
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('출발역과 도착역을 모두 선택해주세요.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // ✅ 선택된 출발/도착역을 SeatPage로 넘김
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeatPage(
                      departureStation: _departureStation,
                      arrivalStation: _arrivalStation,
                    ),
                  ),
                );
              }
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
          )
        ],
      ),
    );
  }
}
