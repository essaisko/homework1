// seat_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ✅ 좌석 선택 페이지 - 출발역과 도착역을 받아서 좌석을 선택하고 예매하는 기능을 제공
class SeatPage extends StatefulWidget {
  final String departureStation; // 선택된 출발역 이름
  final String arrivalStation; // 선택된 도착역 이름

  const SeatPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
  });

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  final Set<String> selectedSeats = {}; // 사용자가 선택한 좌석들을 저장하는 Set

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('좌석 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 뒤로가기 버튼
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildRouteHeader(), // 🔽 출발역 → 도착역 표시
            const SizedBox(height: 12),
            _buildLegend(), // 🔽 좌석 상태(선택됨/선택안됨) 설명
            const SizedBox(height: 10),
            _buildSeatCount(), // 🔽 현재 선택된 좌석 개수 출력
            const SizedBox(height: 20),
            _buildSeatLabels(), // 🔽 상단 열 라벨 (A, B, C, D)
            const SizedBox(height: 20),
            Expanded(child: _buildSeatGrid()), // 🔽 좌석 배치 리스트뷰
            const SizedBox(height: 10),
            _buildBookingButton(context), // 🔽 예매 버튼
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// 🔽 출발역 → 도착역 텍스트 표시 위젯
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

  /// 🔽 좌석 상태 표시 (선택됨 / 선택안됨)
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendBox(Colors.purple),
        const SizedBox(width: 4),
        const Text('선택됨'),
        const SizedBox(width: 20),
        _legendBox(Colors.grey[300]!),
        const SizedBox(width: 4),
        const Text('선택안됨'),
      ],
    );
  }

  /// 🔽 현재 선택된 좌석 개수 표시
  Widget _buildSeatCount() {
    return Text(
      '선택된 좌석: ${selectedSeats.length}개',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  /// 🔽 좌석 열 라벨 (A, B, C, D)
  Widget _buildSeatLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _seatLabel('A'),
        const SizedBox(width: 4),
        _seatLabel('B'),
        const SizedBox(width: 16),
        _seatLabel(''),
        const SizedBox(width: 16),
        _seatLabel('C'),
        const SizedBox(width: 4),
        _seatLabel('D'),
      ],
    );
  }

  /// 🔽 실제 좌석 버튼 구성 (20줄)
  Widget _buildSeatGrid() {
    return ListView.builder(
      itemCount: 20,
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

  /// 🔽 예매 버튼 (선택 좌석 없으면 비활성화)
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

  /// 🔽 예매 확인 다이얼로그
  void _confirmBooking(BuildContext context) {
    final reserved = selectedSeats.toList()
      ..sort((a, b) {
        final letterCompare = a[0].compareTo(b[0]);
        if (letterCompare != 0) return letterCompare;
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

  /// 🔽 좌석 버튼 위젯
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
            color: isSelected ? Colors.purple : Colors.grey[300]!,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// 🔽 좌석 라벨 (A, B, C, D 등)
  Widget _seatLabel(String label) =>
      _squareBox(Text(label, style: const TextStyle(fontSize: 18)));

  /// 🔽 행 번호 라벨 (1~20)
  Widget _rowNumberLabel(String number) =>
      _squareBox(Text(number, style: const TextStyle(fontSize: 18)));

  /// 🔽 좌석 상태 박스
  Widget _legendBox(Color color) => Container(
        width: 24,
        height: 24,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      );

  /// 🔽 좌석 및 라벨을 감싸는 사각형 박스 (50x50)
  Widget _squareBox(Widget child) => SizedBox(
        width: 50,
        height: 50,
        child: Center(child: child),
      );
}
