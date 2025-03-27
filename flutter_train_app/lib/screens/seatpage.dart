import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ✅ 좌석 선택 페이지: 출발역 ↔ 도착역을 전달받고, 좌석을 선택해서 예매하는 화면
class SeatPage extends StatefulWidget {
  final String departureStation; // 출발역 이름
  final String arrivalStation; // 도착역 이름

  const SeatPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
  });

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  /// ✅ 현재 선택된 좌석을 저장하는 Set
  final Set<String> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('좌석 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 출발역 → 도착역 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.departureStation,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_circle_right_outlined, size: 30),
                const SizedBox(width: 8),
                Text(
                  widget.arrivalStation,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✅ 좌석 상태 설명 (선택됨 / 선택안됨)
            Row(
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
            ),

            const SizedBox(height: 10),

            // ✅ 선택 좌석 수 출력
            Text(
              '선택된 좌석: ${selectedSeats.length}개',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 좌석 열 라벨 (A B [번호] C D)
            Row(
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
            ),

            const SizedBox(height: 20),

            // ✅ 20줄의 좌석 표시 (스크롤)
            Expanded(
              child: ListView.builder(
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
                        _rowNumberLabel('$row'), // 가운데 행 번호
                        const SizedBox(width: 16),
                        _seatButton('C$row'),
                        const SizedBox(width: 4),
                        _seatButton('D$row'),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ✅ 예매 버튼
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedSeats.isEmpty
                      ? null
                      : () {
                          // ✅ 선택된 좌석 정렬 및 포맷 (A-1, A-2 순)
                          final reserved = selectedSeats.toList()
                            ..sort((a, b) {
                              final letterCompare = a[0].compareTo(b[0]);
                              if (letterCompare != 0) return letterCompare;
                              return int.parse(a.substring(1))
                                  .compareTo(int.parse(b.substring(1)));
                            });

                          final reservedText = reserved
                              .map((seat) => "${seat[0]}-${seat.substring(1)}")
                              .join(', ');

                          // ✅ 예매 확인 다이얼로그
                          showCupertinoDialog(
                            context: context,
                            builder: (ctx) => CupertinoAlertDialog(
                              title: const Text("예매 하시겠습니까?"),
                              content: Text("좌석: $reservedText"),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text("취소",
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                CupertinoDialogAction(
                                  child: const Text("확인"),
                                  onPressed: () {
                                    // ✅ 다이얼로그 닫고 → 이전 두 화면으로 이동
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '예매 하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// ✅ 좌석 위젯 (선택 토글)
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

  /// ✅ 열 이름 위젯 (A, B, C, D)
  Widget _seatLabel(String label) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  /// ✅ 행 번호 위젯 (1~20)
  Widget _rowNumberLabel(String number) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  /// ✅ 좌석 상태 박스 (선택됨/선택안됨 표시용)
  Widget _legendBox(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
