import 'dart:io';
import 'dart:math';

// 캐릭터 클래스
class Character {
  String name;
  int health, attack, defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = attack;
    monster.health -= damage;
    print("\n$name이(가) ${monster.name}에게 $damage의 피해를 입혔습니다.");
  }

  void defend() {
    print("\n$name이(가) 방어 태세를 취하여 0 만큼 체력을 잃었습니다.");
  }

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }
}

// 몬스터 클래스
class Monster {
  String name;
  int health, attack;

  Monster(this.name, this.health, int attackMax) : attack = max(attackMax, 5);

  void attackCharacter(Character character) {
    int damage = max(attack - character.defense, 0);
    character.health -= damage;
    print("\n$name이(가) ${character.name}에게 $damage의 피해를 입혔습니다.");
  }

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack");
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

  void battle() {
    while (character.health > 0 && monsters.isNotEmpty) {
      var monster = getRandomMonster();
      print("\n새로운 몬스터가 나타났습니다!");
      print(
          "\n${monster.name} - 체력: ${monster.health}, 공격력: ${monster.attack}");

      while (character.health > 0 && monster.health > 0) {
        print("\n${character.name}의 턴");
        print("행동을 선택하세요 (1: 공격, 2: 방어):");
        String input;
        do {
          input = stdin.readLineSync() ?? '';
        } while (input != '1' && input != '2');

        if (input == '1') {
          character.attackMonster(monster);
        } else {
          character.defend();
        }

        print("\n현재 상태:");
        character.showStatus();
        monster.showStatus();

        if (monster.health > 0) {
          print("\n${monster.name}의 턴");
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
    print("게임 종료! 승리한 몬스터 수: $defeatedMonsters");
    saveGameResult();
  }

  void saveGameResult() {
    String input;
    do {
      print("결과를 저장하시겠습니까? (y/n)");
      input = stdin.readLineSync()?.toLowerCase() ?? '';
    } while (input != 'y' && input != 'n');

    if (input == 'y') {
      String result = character.health > 0 ? "승리" : "패배";
      String content =
          "캐릭터: ${character.name}, 남은 체력: ${character.health}, 결과: $result";
      File('result.txt').writeAsStringSync(content);
      print("게임 결과가 result.txt에 저장되었습니다.");
    } else {
      print("게임 결과 저장을 취소했습니다.");
    }
  }
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
    print("⚠️ 올바른 이름을 입력하세요! (한글, 영문 대소문자만 가능)");
  }
}

void main() {
  String name = getCharacterName();
  print("\n게임을 시작합니다!\n");

  final file = File('characters.txt');
  var stats = file.readAsStringSync().split(',');
  Character player = Character(
      name, int.parse(stats[0]), int.parse(stats[1]), int.parse(stats[2]));

  print("\n캐릭터 정보:");
  player.showStatus();

  Game game = Game(player);
  game.loadMonsters();
  game.battle();
}
