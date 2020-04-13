import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("jwt token test", () {
    String token =
        "eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxMDJmMGM2MmM0YjhkNTE4YzhiYzk5NGNhMzE2OWIyZCIsInN1YiI6Im1pbmdvciIsImV4cCI6MTU4NjgzODkyNCwiaWF0IjoxNTg2NzUyNTI0fQ.pSc5-SQE9lsId7v-Me0dAE0JobXtwO7j45u5-iGZTqY";

    var decodeToken = new JWT.parse(token);

    print((DateTime.now().millisecondsSinceEpoch / 1000).toInt());

    print(decodeToken.claims["exp"]);
  });
}
