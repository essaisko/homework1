import 'package:flutter/material.dart';

/// ✅ 출발역 또는 도착역을 선택하는 공용 페이지
/// [title] 은 앱바 제목 ('출발역' 또는 '도착역')
/// [excludeStation] 은 이미 선택된 역으로, 리스트에서 제외됨
class StationListPage extends StatelessWidget {
  final String title;
  final String? excludeStation; // 출발역 or 도착역 중, 반대쪽에서 이미 선택된 역

  const StationListPage({
    super.key,
    required this.title,
    this.excludeStation,
  });

  /// ✅ 전체 역 리스트 (수서 ~ 부산)
  static const List<String> _allStations = [
    '수서',
    '동탄',
    '평택지제',
    '천안아산',
    '오송',
    '대전',
    '김천구미',
    '동대구',
    '경주',
    '울산',
    '부산',
  ];

  @override
  Widget build(BuildContext context) {
    /// ✅ 제외된 역을 뺀 최종 표시 리스트
    /// 예: 출발역이 '부산'으로 선택되었으면 부산은 도착역 리스트에서 제외
    final stationNames = excludeStation == null
        ? _allStations
        : _allStations.where((name) => name != excludeStation).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title), // 앱 상단 제목: '출발역' or '도착역'
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // ← 뒤로가기
        ),
      ),

      /// ✅ 역 리스트 출력 (ListView)
      body: ListView.separated(
        itemCount: stationNames.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[300], // 각 항목 구분선
        ),
        itemBuilder: (context, index) {
          final station = stationNames[index];
          return ListTile(
            title: Text(
              station,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // ✅ 선택한 역을 이전 페이지로 전달하고 종료
              Navigator.pop(context, station);
            },
          );
        },
      ),
    );
  }
}
