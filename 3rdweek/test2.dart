import 'dart:io';
import 'dart:math';

// 캐릭터 클래스 정의
class Character {
  String name; // 캐릭터 이름
  int health; // 캐릭터의 체력
  int attack; // 캐릭터의 공격력
  int defense; // 캐릭터의 방어력
  bool itemUsed = false; // 아이템 사용 여부를 체크하는 변수

  // 캐릭터 생성자
  Character(this.name, this.health, this.attack, this.defense);

  // 몬스터 공격 메서드
  void attackMonster(Monster monster, {bool item = false}) {
    // 아이템 사용 시 공격력이 두 배
    int damage = item ? attack * 2 : attack;

    // 몬스터 회피 확률을 체크하여 공격 여부 결정
    if (Random().nextInt(100) < monster.evasionChance) {
      print("\n${monster.name}이(가) ${name}의 공격을 회피했습니다!");
      return;
    }

    // 몬스터의 방어력을 고려한 실제 데미지 계산
    damage = max(damage - monster.defense, 0);
    monster.health -= damage;
    print("\n$name이(가) ${monster.name}에게 $damage의 피해를 입혔습니다.");
  }

  // 방어 메서드
  void defend() {
    print("\n$name이(가) 방어 태세를 취하여 0 만큼 체력을 잃었습니다.");
  }

  // 캐릭터 상태 출력 메서드
  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }

  // 아이템 사용 메서드
  void useItem() {
    itemUsed = true;
    print("\n아이템 사용! 이번 턴 공격력이 두 배로 증가합니다.");
  }
}

// 몬스터 클래스 정의
class Monster {
  String name; // 몬스터 이름
  int health; // 몬스터 체력
  int attack; // 몬스터 공격력
  int defense = 0; // 몬스터 방어력 (기본값 0)
  int turnCount = 0; // 방어력 증가를 위한 턴 카운터
  int evasionChance; // 몬스터의 회피 확률

  // 몬스터 생성자
  Monster(this.name, this.health, int attackMax)
      : attack = max(attackMax, 5),
        evasionChance = Random().nextInt(10) + 1; // 1~10% 회피 확률 랜덤 설정

  // 캐릭터 공격 메서드
  void attackCharacter(Character character) {
    // 캐릭터의 방어력을 고려한 실제 데미지 계산
    int damage = max(attack - character.defense, 0);
    character.health -= damage;
    print("\n$name이(가) ${character.name}에게 $damage의 피해를 입혔습니다.");
  }

  // 3턴마다 몬스터의 방어력 증가 메서드
  void increaseDefense() {
    turnCount++;
    if (turnCount % 3 == 0) {
      defense += 2;
      print("\n$name의 방어력이 증가했습니다! 현재 방어력: $defense");
    }
  }

  // 몬스터 상태 출력 메서드
  void showStatus() {
    print(
        "$name - 체력: $health, 공격력: $attack, 방어력: $defense, 회피율: $evasionChance%");
  }
}

// 게임 클래스 정의
class Game {
  Character character; // 플레이어 캐릭터 인스턴스
  List<Monster> monsters = []; // 게임에서 사용할 몬스터 리스트
  int defeatedMonsters = 0; // 처치한 몬스터 수

  // 게임 생성자
  Game(this.character);

  // 파일에서 몬스터 정보 로드
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
            print("\n아이템을 이미 사용했습니다. 다른 행동을 선택하세요.");
            continue;
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
        print("\n다음 몬스터와 싸우시겠습니까? (y/n)");
        var input = stdin.readLineSync()?.toLowerCase() ?? '';
        if (input != 'y') break;
      }
    }
    print("게임 종료! 승리한 몬스터 수: $defeatedMonsters");
    saveGameResult(character);
  }

  // 게임 결과 저장 메서드
  void saveGameResult(Character character) {
    print("결과를 저장하시겠습니까? (y/n)");
    var input = stdin.readLineSync()?.toLowerCase();
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
}

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
