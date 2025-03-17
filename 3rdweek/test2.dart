import 'dart:io';
import 'dart:math';

// 캐릭터 클래스
class Character {
  String name;
  int health, attack, defense;
  bool itemUsed = false; // 아이템 사용 여부 확인

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster, {bool item = false}) {
    int damage = item ? attack * 2 : attack;
    damage = max(damage - monster.defense, 0);
    monster.health -= damage;
    print("\n$name이(가) ${monster.name}에게 $damage의 피해를 입혔습니다.");
  }

  void defend() {
    print("\n$name이(가) 방어 태세를 취하여 0 만큼 체력을 잃었습니다.");
  }

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }

  void useItem() {
    if (!itemUsed) {
      itemUsed = true;
      print("\n아이템 사용! 이번 턴 공격력이 두 배로 증가합니다.");
    } else {
      print("\n이미 아이템을 사용했습니다.");
    }
  }
}

// 몬스터 클래스
class Monster {
  String name;
  int health, attack, defense = 0, turnCount = 0;

  Monster(this.name, this.health, int attackMax) : attack = max(attackMax, 5);

  void attackCharacter(Character character) {
    int damage = max(attack - character.defense, 0);
    character.health -= damage;
    print("\n$name이(가) ${character.name}에게 $damage의 피해를 입혔습니다.");
  }

  void increaseDefense() {
    turnCount++;
    if (turnCount % 3 == 0) {
      defense += 2;
      print("\n$name의 방어력이 증가했습니다! 현재 방어력: $defense");
    }
  }

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }
}

// 게임 클래스
class Game {
  Character character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;

  Game(this.character);

  void loadMonsters() {
    try {
      final file = File('monsters.txt');
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

  Monster getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  void provideBonusHealth() {
    if (Random().nextInt(100) < 30) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: \${character.health}');
    }
  }

  void battle() {
    provideBonusHealth();

    while (character.health > 0 && monsters.isNotEmpty) {
      var monster = getRandomMonster();
      print("\n새로운 몬스터가 나타났습니다!");
      monster.showStatus();

      while (character.health > 0 && monster.health > 0) {
        print("\n${character.name}의 턴");
        print("행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용):");
        String input;
        do {
          input = stdin.readLineSync() ?? '';
        } while (!['1', '2', '3'].contains(input));

        if (input == '1') {
          character.attackMonster(monster);
        } else if (input == '2') {
          character.defend();
        } else if (input == '3') {
          if (!character.itemUsed) {
            character.useItem();
            character.attackMonster(monster, item: true);
          } else {
            print("\n아이템을 이미 사용하여 일반 공격으로 대체됩니다.");
            character.attackMonster(monster);
          }
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
        String input;
        do {
          print("\n다음 몬스터와 싸우시겠습니까? (y/n)");
          input = stdin.readLineSync()?.toLowerCase() ?? '';
        } while (input != 'y' && input != 'n');
        if (input == 'n') break;
      }
    }
    if (monsters.isEmpty) {
      print("\n🎉 축하합니다! 모든 몬스터를 물리쳤습니다! 🎉");
    }
    print("게임 종료! 승리한 몬스터 수: $defeatedMonsters");
    saveGameResult(character);
  }

  void saveGameResult(Character character) {
    print("결과를 저장하시겠습니까? (y/n)");
    var input = stdin.readLineSync()?.toLowerCase();
    if (input == 'y') {
      String result = character.health > 0 ? "승리" : "패배"; // 여기에 변수 선언 추가
      String content =
          "${character.name}님의 게임 결과: $result (체력: ${character.health})";
      File('result.txt').writeAsStringSync(content);
      print("게임 결과가 result.txt에 저장되었습니다.");
    } else {
      print("게임 결과 저장을 취소했습니다.");
    }
  }

  void main() {
    String name = getCharacterName();
    final file = File('characters.txt');
    var stats = file.readAsStringSync().split(',');
    Character player = Character(
        name, int.parse(stats[0]), int.parse(stats[1]), int.parse(stats[2]));

    player.showStatus();
    Game game = Game(player);
    game.loadMonsters();
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
}
