import 'dart:io';
import '../lib/Character.dart';
import '../lib/Game.dart';

// 게임 클래스 정의

void main() {
  String name = getCharacterName();

  // 캐릭터 데이터를 characters.txt 파일에서 로드
  final file = File('characters.txt');
  var stats = file.readAsStringSync().split(',');

  // 캐릭터 인스턴스 생성
  Character player = Character(
    name,
    int.parse(stats[0]),
    int.parse(stats[1]),
    int.parse(stats[2]),
  );

  player.showStatus(); // 캐릭터 상태 출력

  // 게임 인스턴스 생성 및 몬스터 로드
  Game game = Game(player);
  game.loadMonsters();

  // 게임 전투 시작
  game.battle();
}

String getCharacterName() {
  while (true) {
    print("캐릭터의 이름을 입력하세요:");
    String? name = stdin.readLineSync();
    if (name != null &&
        name.isNotEmpty &&
        RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
      return name;
    }
    print("이름은 한글 또는 영문만 가능합니다. 다시 입력해주세요.");
  }
}
