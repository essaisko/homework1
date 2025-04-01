import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ✅ 좌석 선택 페이지: 출발역과 도착역 정보를 받아 좌석을 선택하고 예매하는 UI
class SeatPage extends StatefulWidget {
  // ✅ 출발역과 도착역은 이 위젯이 만들어질 때 꼭 전달받아야 함 (required)
  final String departureStation;
  final String arrivalStation;

  const SeatPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
  });

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  /// ✅ 사용자가 선택한 좌석을 저장할 Set
  /// - Set은 중복이 허용되지 않는 자료구조
  /// - String 형태의 좌석 ID 저장 (예: A1, B2 등)
  final Set<String> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좌석 선택'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 이전 화면으로 돌아감
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildRouteHeader(), // 🔽 출발 → 도착 표시
            const SizedBox(height: 12),
            _buildLegend(), // 🔽 좌석 상태 설명 (선택됨/안됨)
            const SizedBox(height: 10),
            _buildSeatCount(), // 🔽 현재 선택 좌석 개수 표시
            const SizedBox(height: 20),
            _buildSeatLabels(), // 🔽 A~D 열 표시
            const SizedBox(height: 20),
            Expanded(child: _buildSeatGrid()), // 🔽 좌석 목록
            const SizedBox(height: 10),
            _buildBookingButton(context), // 🔽 예매 버튼
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// ✅ [출발역 → 도착역] 정보 표시
  Widget _buildRouteHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.departureStation,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_circle_right_outlined, size: 30),
        const SizedBox(width: 8),
        Text(
          widget.arrivalStation,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
      ],
    );
  }

  /// ✅ 좌석 상태(선택됨 / 선택안됨) 안내 UI
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendBox(Colors.purple),
        const SizedBox(width: 4),
        const Text('선택됨'),
        const SizedBox(width: 20),
        _legendBox(Colors.grey),
        const SizedBox(width: 4),
        const Text('선택안됨'),
      ],
    );
  }

  /// ✅ 선택된 좌석 개수 표시
  Widget _buildSeatCount() {
    return Text(
      '선택된 좌석: ${selectedSeats.length}개',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  /// ✅ A~D 열 라벨 표시
  Widget _buildSeatLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _seatLabel('A'),
        const SizedBox(width: 4),
        _seatLabel('B'),
        const SizedBox(width: 16),
        _seatLabel(''), // 가운데 공간
        const SizedBox(width: 16),
        _seatLabel('C'),
        const SizedBox(width: 4),
        _seatLabel('D'),
      ],
    );
  }

  /// ✅ 좌석 배치 (20줄 × A~D)
  Widget _buildSeatGrid() {
    return ListView.builder(
      itemCount: 20, // 총 20줄
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final row = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _seatButton('A$row'),
              const SizedBox(width: 4),
              _seatButton('B$row'),
              const SizedBox(width: 16),
              _rowNumberLabel('$row'),
              const SizedBox(width: 16),
              _seatButton('C$row'),
              const SizedBox(width: 4),
              _seatButton('D$row'),
            ],
          ),
        );
      },
    );
  }

  /// ✅ 예매 버튼 - 선택된 좌석이 있어야 활성화됨
  Widget _buildBookingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed:
              selectedSeats.isEmpty ? null : () => _confirmBooking(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            disabledBackgroundColor: Colors.grey[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text(
            '예매 하기',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// ✅ 예매 확인 다이얼로그 (Cupertino 스타일)
  void _confirmBooking(BuildContext context) {
    final reserved = selectedSeats.toList()
      ..sort((a, b) {
        // 알파벳 → 숫자 순 정렬
        final compareLetter = a[0].compareTo(b[0]);
        if (compareLetter != 0) return compareLetter;
        return int.parse(a.substring(1)).compareTo(int.parse(b.substring(1)));
      });

    final reservedText =
        reserved.map((seat) => "${seat[0]}-${seat.substring(1)}").join(', ');

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("예매 하시겠습니까?"),
        content: Text("좌석: $reservedText"),
        actions: [
          CupertinoDialogAction(
            child: const Text("취소", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoDialogAction(
            child: const Text("확인"),
            onPressed: () {
              Navigator.of(ctx).pop(); // 다이얼로그 닫기
              Navigator.of(context)
                  .popUntil((route) => route.isFirst); // 홈으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('예매 완료! 좌석: $reservedText'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// ✅ 좌석 하나에 대한 버튼
  Widget _seatButton(String seatId) {
    final isSelected = selectedSeats.contains(seatId);

    return SizedBox(
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected
                ? selectedSeats.remove(seatId)
                : selectedSeats.add(seatId);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// ✅ 열 라벨 위젯 (A, B, C, D)
  Widget _seatLabel(String label) => _squareBox(
        Text(label, style: const TextStyle(fontSize: 18)),
      );

  /// ✅ 줄 번호 라벨 (1~20)
  Widget _rowNumberLabel(String number) => _squareBox(
        Text(number, style: const TextStyle(fontSize: 18)),
      );

  /// ✅ 색상 박스 (좌석 상태용)
  Widget _legendBox(Color color) => Container(
        width: 24,
        height: 24,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      );

  /// ✅ 50x50 정사각형 박스에 자식 위젯 넣기
  Widget _squareBox(Widget child) => SizedBox(
        width: 50,
        height: 50,
        child: Center(child: child),
      );
}
