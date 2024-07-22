import 'package:flutter/cupertino.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';

/// This class helps to recognize user selected condition and check them
class ConditionsHelper {
  ConditionsHelper(this.strings);

  final FlutterPwValidatorStrings strings;
  Map<String, bool>? _selectedCondition;

  /// Recognize user selected condition from widget constructor to put them on map with their value
  void setSelectedCondition(
    int minLength,
    int normalCharCount,
    int uppercaseCharCount,
    int lowercaseCharCount,
    int numericCharCount,
    int specialCharCount, [
    bool? hasMinLength,
    bool? hasMinNormalChar,
    bool? hasMinUppercaseChar,
    bool? hasMinLowercaseChar,
    bool? hasMinNumericChar,
    bool? hasMinSpecialChar,
  ]) {
    _selectedCondition = {
      if (minLength > 0) strings.atLeast: hasMinLength ?? false,
      if (normalCharCount > 0) strings.normalLetters: hasMinNormalChar ?? false,
      if (uppercaseCharCount > 0) strings.uppercaseLetters: hasMinUppercaseChar ?? false,
      if (lowercaseCharCount > 0) strings.lowercaseLetters: hasMinLowercaseChar ?? false,
      if (numericCharCount > 0) strings.numericCharacters: hasMinNumericChar ?? false,
      if (specialCharCount > 0) strings.specialCharacters: hasMinSpecialChar ?? false,
    };
  }

  /// Checks condition value and passed validator, sets that in map and return value;
  bool? checkCondition(
    int userRequestedValue,
    bool Function(String password, int minLength) validator,
    TextEditingController controller,
    String key,
    bool? oldValue,
  ) {
    bool? newValue;

    /// If the userRequested Value is grater than 0 that means user select them and we have to check value;
    if (userRequestedValue > 0) {
      newValue = validator(controller.text, userRequestedValue);
    } else {
      newValue = null;
    }

    if (newValue == null) {
      return null;
    } else if (newValue != oldValue) {
      _selectedCondition![key] = newValue;
      return newValue;
    } else {
      return oldValue;
    }
  }

  Map<String, bool>? getter() => _selectedCondition;
}
