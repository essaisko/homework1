import 'dart:io';

class Product {
  // 상품 클래스 생성
  final String name;
  final int price;

  Product(this.name, this.price);

  @override
  String toString() {
    return '$name / ${price}원';
  }
}

class ShoppingMall {
  // 쇼핑몰 클래스 생성
  final List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];

  int totalPrice = 0;
  final List<Product> cart = [];

  void showProducts() {
    // 상품 목록 출력 메서드
    print('\n[상품 목록]');
    for (var product in products) {
      print(product);
    }
  }

  void addToCart() {
    // 장바구니에 상품 추가 메서드
    String? productName = _getUserInput('\n상품 이름을 입력해 주세요!\n> ');
    var selectedProduct = products.firstWhere(
      (p) => p.name == productName,
      orElse: () => Product('', 0),
    );

    if (selectedProduct.name.isEmpty) {
      print('입력값이 올바르지 않아요!');
      return;
    }

    int? quantity =
        int.tryParse(_getUserInput('상품 개수를 입력해 주세요!\n> ') ?? ''); // 상품 개수 입력

    if (quantity == null || quantity <= 0) {
      print('0개보다 많은 개수의 상품만 담을 수 있어요!');
      return;
    }

    for (int i = 0; i < quantity; i++) {
      // 상품 개수만큼 장바구니에 추가
      cart.add(selectedProduct);
    }
    totalPrice += selectedProduct.price * quantity;
    print('장바구니에 상품이 담겼어요!');
  }

  void showTotal() {
    // 장바구니 총 가격 출력 메서드
    if (cart.isEmpty) {
      print('\n장바구니에 담긴 상품이 없습니다.');
    } else {
      var productNames = cart.map((product) => product.name).toSet().toList();
      print('\n장바구니에 ${productNames.join(', ')}가 담겨있네요. 총 ${totalPrice}원 입니다!');
    }
  }

  void clearCart() {
    // 장바구니 초기화 메서드
    if (cart.isEmpty) {
      print('이미 장바구니가 비어있습니다.');
    } else {
      cart.clear();
      totalPrice = 0;
      print('장바구니를 초기화합니다.');
    }
  }

  String? _getUserInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync()?.trim();
  }
}

void main() {
  // 메인 함수
  ShoppingMall mall = ShoppingMall();
  bool running = true;

  while (running) {
    print(
        '-------------------------------------------------------------------------------------------------------------');
    print(
        '\n[1] 상품 목록 보기 | [2] 장바구니에 담기 | [3] 장바구니 총 가격 보기 | [4] 프로그램 종료 | [6] 장바구니 초기화');
    print(
        '-------------------------------------------------------------------------------------------------------------');

    String? choice = mall._getUserInput('메뉴를 선택하세요: ');

    switch (choice) {
      case '1': // 상품 목록 보기
        mall.showProducts();
        break;
      case '2': // 장바구니에 상품 담기
        mall.addToCart();
        break;
      case '3': // 장바구니 총 가격 보기
        mall.showTotal();
        break;
      case '4': // 프로그램 종료
        String? confirm = mall._getUserInput('정말 종료하시겠습니까? (종료하려면 5를 입력하세요): ');
        if (confirm == '5') {
          // 종료 확인
          print('\n이용해 주셔서 감사합니다 ~ 안녕히 가세요!');
          running = false;
        } else {
          print('종료하지 않습니다.');
        }
        break;
      case '6':
        mall.clearCart(); // 장바구니 초기화
        break;
      default:
        print('지원하지 않는 기능입니다! 다시 시도해주세요 ..');
    }
  }
}
