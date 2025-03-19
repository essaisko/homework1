// 몬스터 클래스 정의
import 'dart:math';

import 'Character.dart';

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
