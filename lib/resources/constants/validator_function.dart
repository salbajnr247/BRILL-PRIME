bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool validPhoneNumber(String value) {
  bool isValid = false;
  if (value.length != 10) {
    isValid = false;
  } else {
    isValid = true;
  }
  return isValid;
}

bool validatePassword(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool contains8Characters(String value) {
  String pattern = r'^.{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool containsUpperLetter(String value) {
  String pattern = r'^(?=.*?[A-Z])';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool containsOneNumber(String value) {
  String pattern = r'^(?=.*?[0-9])';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool containsOneSspecialCharacter(String value) {
  String pattern = r'[!@#$%^&*(),.?":{}|<>]';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}
