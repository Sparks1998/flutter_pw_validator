library flutter_pw_validator;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Utilities/ConditionsHelper.dart';
import 'package:flutter_pw_validator/Utilities/Validator.dart';

import 'Components/ValidationBarWidget.dart';
import 'Components/ValidationTextWidget.dart';
import 'Resource/MyColors.dart';
import 'Resource/Strings.dart';

class FlutterPwValidator extends StatefulWidget {
  final Key? key;
  final int minLength, normalCharCount, uppercaseCharCount, lowercaseCharCount, numericCharCount, specialCharCount;
  final Color defaultColor, successColor, failureColor;
  final double? width, height;
  final double indicatorRadius, fontSize, barsSpacing, validationBarThickness;
  final void Function()? onSuccess;
  final void Function()? onFail;
  final TextEditingController controller;
  final FlutterPwValidatorStrings? strings;
  final double textBarSpacing;
  final EdgeInsetsGeometry margin;
  final bool showValidationBar, showValidationText;
  final TextStyle? style;
  final EdgeInsetsGeometry validationTextPadding;

  FlutterPwValidator({
    this.key,
    required this.controller,
    this.onSuccess,
    this.minLength = 0,
    this.width,
    this.height,
    this.uppercaseCharCount = 0,
    this.lowercaseCharCount = 0,
    this.numericCharCount = 0,
    this.specialCharCount = 0,
    this.normalCharCount = 0,
    this.defaultColor = MyColors.gray,
    this.successColor = MyColors.green,
    this.failureColor = MyColors.red,
    this.indicatorRadius = 6,
    this.strings,
    this.onFail,
    this.fontSize = 12,
    this.textBarSpacing = 0,
    this.margin = EdgeInsets.zero,
    this.barsSpacing = 2.0,
    this.validationBarThickness = 6.0,
    this.showValidationBar = true,
    this.showValidationText = true,
    this.style,
    this.validationTextPadding = EdgeInsets.zero,
  });

  @override
  State<StatefulWidget> createState() => FlutterPwValidatorState();
}

@protected
class FlutterPwValidatorState extends State<FlutterPwValidator> {
  /// Estimate that this the first run or not
  late bool _isFirstRun;

  /// Variables that hold current condition states
  bool _hasMinLength = false,
      _hasMinNormalChar = false,
      _hasMinUppercaseChar = false,
      _hasMinLowercaseChar = false,
      _hasMinNumericChar = false,
      _hasMinSpecialChar = false;

  //Initial instances of ConditionHelper and Validator class
  late final ConditionsHelper _conditionsHelper;
  Validator _validator = Validator();

  /// Get called each time that user entered a character in EditText
  void validate({bool allowSetState = true}) {
    /// For each condition we called validators and get their state
    _hasMinLength = _conditionsHelper.checkCondition(
      widget.minLength,
      _validator.hasMinLength,
      widget.controller,
      translatedStrings.atLeast,
      _hasMinLength,
    );

    _hasMinNormalChar = _conditionsHelper.checkCondition(
      widget.normalCharCount,
      _validator.hasMinNormalChar,
      widget.controller,
      translatedStrings.normalLetters,
      _hasMinNormalChar,
    );

    _hasMinUppercaseChar = _conditionsHelper.checkCondition(
      widget.uppercaseCharCount,
      _validator.hasMinUppercase,
      widget.controller,
      translatedStrings.uppercaseLetters,
      _hasMinUppercaseChar,
    );

    _hasMinLowercaseChar = _conditionsHelper.checkCondition(
      widget.lowercaseCharCount,
      _validator.hasMinLowercase,
      widget.controller,
      translatedStrings.lowercaseLetters,
      _hasMinLowercaseChar,
    );

    _hasMinNumericChar = _conditionsHelper.checkCondition(
      widget.numericCharCount,
      _validator.hasMinNumericChar,
      widget.controller,
      translatedStrings.numericCharacters,
      _hasMinNumericChar,
    );

    _hasMinSpecialChar = _conditionsHelper.checkCondition(
      widget.specialCharCount,
      _validator.hasMinSpecialChar,
      widget.controller,
      translatedStrings.specialCharacters,
      _hasMinSpecialChar,
    );

    /// Checks if all condition are true then call the onSuccess and if not, calls onFail method
    int conditionsCount = _conditionsHelper.getter()!.length;
    int trueCondition = 0;
    for (bool value in _conditionsHelper.getter()!.values) {
      if (value == true) trueCondition += 1;
    }
    if (conditionsCount == trueCondition) {
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    } else if (widget.onFail != null) {
      widget.onFail!();
    }

    //Rebuild the UI
    if (allowSetState) {
      //To prevent from calling the setState() after dispose()
      if (!mounted) return;
      setState(() => null);
    }
    trueCondition = 0;
  }

  @override
  void initState() {
    super.initState();
    _isFirstRun = true;

    _conditionsHelper = ConditionsHelper(translatedStrings);

    /// Sets user entered value for each condition
    _conditionsHelper.setSelectedCondition(
      widget.minLength,
      widget.normalCharCount,
      widget.uppercaseCharCount,
      widget.lowercaseCharCount,
      widget.numericCharCount,
      widget.specialCharCount,
    );

    validate(allowSetState: false);

    /// Adds a listener callback on TextField to run after input get changed
    widget.controller.addListener(() {
      _isFirstRun = false;
      validate();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.showValidationBar)
                  Flexible(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        _conditionsHelper.getter()!.values.length,
                        (index) {
                          bool value = _conditionsHelper.getter()!.values.elementAt(index);

                          return ValidationBarComponent(
                            color: value ? widget.successColor : widget.defaultColor,
                            total: _conditionsHelper.getter()!.values.length,
                            index: index,
                            spacing: widget.barsSpacing,
                            validationBarThickness: widget.validationBarThickness,
                          );
                        },
                      ),
                    ),
                  ),
                if (widget.showValidationText)
                  Flexible(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.only(top: widget.textBarSpacing),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,

                        //Iterate through the condition map entries and generate ValidationTextWidget for each item in Green or Red Color
                        children: _conditionsHelper.getter()!.entries.map(
                          (entry) {
                            int? value;

                            if (entry.key == translatedStrings.atLeast) {
                              value = widget.minLength;
                            } else if (entry.key == translatedStrings.normalLetters) {
                              value = widget.normalCharCount;
                            } else if (entry.key == translatedStrings.uppercaseLetters) {
                              value = widget.uppercaseCharCount;
                            } else if (entry.key == translatedStrings.lowercaseLetters) {
                              value = widget.lowercaseCharCount;
                            } else if (entry.key == translatedStrings.numericCharacters) {
                              value = widget.numericCharCount;
                            } else if (entry.key == translatedStrings.specialCharacters) {
                              value = widget.specialCharCount;
                            }

                            return ValidationTextWidget(
                              color: _isFirstRun && !entry.value
                                  ? widget.defaultColor
                                  : entry.value
                                      ? widget.successColor
                                      : widget.failureColor,
                              text: entry.key,
                              value: value,
                              indicatorRadius: widget.indicatorRadius,
                              fontSize: widget.fontSize,
                              validationTextPadding: widget.validationTextPadding,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  FlutterPwValidatorStrings get translatedStrings => widget.strings ?? FlutterPwValidatorStrings();
}
