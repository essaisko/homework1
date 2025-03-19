import 'dart:io';
import 'dart:math';

import 'Character.dart';
import 'Monster.dart';

class Game {
  Character character; // 플레이어 캐릭터 인스턴스
  List<Monster> monsters = []; // 게임에서 사용할 몬스터 리스트
  int defeatedMonsters = 0; // 처치한 몬스터 수

  // 게임 생성자
  Game(this.character);

  // 파일에서 몬스터 정보 로드
  void loadMonsters() {
    try {
      final file = File('../lib/monsters.txt');
      final lines = file.readAsLinesSync();
      for (var line in lines) {
        var data = line.split(',');
        if (data.length == 3) {
          monsters
              .add(Monster(data[0], int.parse(data[1]), int.parse(data[2])));
        }
      }
    } catch (e) {
      print("몬스터 데이터를 불러오지 못했습니다: $e");
    }
  }

  // 무작위 몬스터 선택 메서드
  Monster getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  // 게임 시작 시 30% 확률로 캐릭터 체력 보너스 부여 메서드
  void provideBonusHealth() {
    if (Random().nextInt(100) < 30) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  // 전투 진행 메서드
  void battle() {
    provideBonusHealth();

    while (character.health > 0 && monsters.isNotEmpty) {
      var monster = getRandomMonster();
      print("\n새로운 몬스터가 나타났습니다!");
      monster.showStatus();

      // 전투마다 아이템 사용 여부 초기화
      character.itemUsed = false;

      while (character.health > 0 && monster.health > 0) {
        print("\n${character.name}의 턴");
        String input;

        // 올바른 입력을 받을 때까지 반복
        while (true) {
          print("행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용):");
          input = stdin.readLineSync() ?? '';

          if (!['1', '2', '3'].contains(input)) {
            print("잘못된 입력입니다. 다시 입력해주세요.\n");
            continue;
          }

          if (input == '3' && character.itemUsed) {
            print("\n아이템을 이미 사용했습니다. 다른 행동을 선택하세요.\n");
            continue;
          }

          break; // 올바른 입력일 때 반복문 탈출
        }

        if (input == '1') {
          character.attackMonster(monster);
        } else if (input == '2') {
          character.defend();
        } else if (input == '3') {
          character.useItem();
          character.attackMonster(monster, item: true);
        }

        if (monster.health > 0) {
          print("\n${monster.name}의 턴");
          monster.increaseDefense();
          monster.attackCharacter(character);

          print("\n현재 상태:");
          character.showStatus();
          monster.showStatus();
        }
      }

      if (monster.health <= 0) {
        print("\n${monster.name}을(를) 물리쳤습니다!");
        monsters.remove(monster);
        defeatedMonsters++;
      }

      if (character.health > 0 && monsters.isNotEmpty) {
        var input = getYesNoInput("\n다음 몬스터와 싸우시겠습니까? (y/n)");
        if (input == 'n') break;
      }
    }

    print("게임 종료! 승리한 몬스터 수: $defeatedMonsters");
    saveGameResult(character);
  }

// 게임 결과 저장 메서드
  void saveGameResult(Character character) {
    var input = getYesNoInput("결과를 저장하시겠습니까? (y/n)");
    if (input == 'y') {
      String result = character.health > 0 ? "승리" : "패배";
      String content =
          "${character.name}님의 게임 결과: $result (체력: ${character.health})";
      File('result.txt').writeAsStringSync(content);
      print("게임 결과가 result.txt에 저장되었습니다.");
    } else {
      print("게임 결과 저장을 취소했습니다.");
    }
  }

  String getYesNoInput(String message) {
    String? input;
    do {
      print(message);
      input = stdin.readLineSync()?.toLowerCase();
      if (input != 'y' && input != 'n') {
        print("잘못된 입력입니다. 다시 입력해주세요.");
      }
    } while (input != 'y' && input != 'n');

    return input!;
  }
}
