/// 邮箱正则
final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

// 验证邮箱
bool validateEmail(String email) {
  if (email == null || email.isEmpty) return false;
  return new RegExp(regexEmail).hasMatch(email);
}
