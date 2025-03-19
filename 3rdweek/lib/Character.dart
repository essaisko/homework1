// 캐릭터 클래스 정의
import 'dart:math';

import 'Monster.dart';

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
    int randomChance = Random().nextInt(100);
    if (randomChance < monster.evasionChance) {
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
