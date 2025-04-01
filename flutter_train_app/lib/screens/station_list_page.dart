import 'package:flutter/material.dart';

/// ✅ 전역 상수: 전체 기차역 리스트 (수서 ~ 부산)
const List<String> allStations = [
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

/// ✅ 출발역 또는 도착역을 선택하는 공용 페이지
/// - [title]: '출발역' 또는 '도착역'
/// - [excludeStation]: 반대쪽에서 이미 선택된 역 (리스트에서 제외됨)
class StationListPage extends StatelessWidget {
  final String title;
  final String? excludeStation;

  const StationListPage({
    super.key,
    required this.title,
    this.excludeStation,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 제외할 역이 있다면 제외한 리스트 생성
    final filteredStations = excludeStation == null
        ? allStations
        : allStations.where((station) => station != excludeStation).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title), // 상단 제목: '출발역' or '도착역'
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // 뒤로 가기
        ),
      ),

      /// ✅ 리스트 형태로 역 이름 출력
      /// ListView.separated: 각 아이템 사이에 구분선(Separator)을 넣을 수 있음
      body: ListView.separated(
        itemCount: filteredStations.length,
        itemBuilder: (context, index) {
          final station = filteredStations[index];
          return ListTile(
            title: Text(
              station,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // ✅ 사용자가 선택한 역을 이전 페이지로 되돌려줌
              Navigator.pop(context, station);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
