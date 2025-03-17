import 'dart:io';
import 'dart:math';

// 캐릭터 클래스
class Character {
  String name;
  int health, attack, defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    monster.health -= attack;
    print("$name이(가) ${monster.name}에게 $attack의 피해를 입혔습니다.");
  }

  void defend() {
    print("$name이(가) 방어 태세를 취해 피해를 줄였습니다.");
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
    print("$name이(가) ${character.name}에게 $damage의 피해를 입혔습니다.");
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
      print("새로운 몬스터 ${monster.name}가 나타났습니다!");

      while (character.health > 0 && monster.health > 0) {
        print("\n${character.name}의 턴 (1: 공격, 2: 방어)");
        character.showStatus();
        monster.showStatus();
        String? input = stdin.readLineSync();
        if (input == '1') {
          character.attackMonster(monster);
        } else {
          character.defend();
        }

        if (monster.health > 0) {
          monster.attackCharacter(character);
        }
      }

      if (monster.health <= 0) {
        print("${monster.name}을(를) 물리쳤습니다!");
        monsters.remove(monster);
        defeatedMonsters++;
      }

      if (character.health > 0 && monsters.isNotEmpty) {
        print("다음 몬스터와 싸우시겠습니까? (y/n)");
        if (stdin.readLineSync()?.toLowerCase() != 'y') break;
      }
    }
    print("게임 종료! 승리한 몬스터 수: $defeatedMonsters");
  }
}

void main() {
  print("캐릭터의 이름을 입력하세요:");
  String name = stdin.readLineSync()!;
  final file = File('characters.txt');
  var stats = file.readAsStringSync().split(',');
  Character player = Character(
      name, int.parse(stats[0]), int.parse(stats[1]), int.parse(stats[2]));

  Game game = Game(player);
  game.loadMonsters();
  game.battle();
}
