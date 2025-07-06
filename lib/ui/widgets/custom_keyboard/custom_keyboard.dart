import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'back_space.dart';
import 'text_key.dart';

class CustomKeyboard extends StatelessWidget {
  final bool isPlainText;
  final bool showBiometricKey;
  const CustomKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    this.onBiometricClicked,
    this.isPlainText = false,
    this.showBiometricKey = false,
  });

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometricClicked;

  void _textInputHandler(String text) => onTextInput.call(text);

  void _backspaceHandler() => onBackspace.call();
  void _biometricHandler() => onBiometricClicked?.call();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRowOne(isPlainText: isPlainText),
        SizedBox(
          height: 25.h,
        ),
        buildRowTwo(isPlainText: isPlainText),
        SizedBox(
          height: 25.h,
        ),
        buildRowThree(isPlainText: isPlainText),
        SizedBox(
          height: 25.h,
        ),
        buildRowFive(isPlainText: isPlainText),
      ],
    );
  }

  Row buildRowOne({bool isPlainText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextKey(
          isPlainText: isPlainText,
          text: '1',
          onTextInput: _textInputHandler,
        ),
        TextKey(
          isPlainText: isPlainText,
          text: '2',
          onTextInput: _textInputHandler,
        ),
        TextKey(
          isPlainText: isPlainText,
          text: '3',
          onTextInput: _textInputHandler,
        ),
      ],
    );
  }

  Row buildRowTwo({bool isPlainText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextKey(
          isPlainText: isPlainText,
          text: '4',
          onTextInput: _textInputHandler,
        ),
        const SizedBox(
          width: 30,
        ),
        TextKey(
          isPlainText: isPlainText,
          text: '5',
          onTextInput: _textInputHandler,
        ),
        const SizedBox(
          width: 30,
        ),
        TextKey(
          isPlainText: isPlainText,
          text: '6',
          onTextInput: _textInputHandler,
        ),
      ],
    );
  }

  Row buildRowThree({bool isPlainText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextKey(
          isPlainText: isPlainText,
          text: '7',
          onTextInput: _textInputHandler,
        ),
        TextKey(
          isPlainText: isPlainText,
          text: '8',
          onTextInput: _textInputHandler,
        ),
        TextKey(
          isPlainText: isPlainText,
          text: '9',
          onTextInput: _textInputHandler,
        ),
      ],
    );
  }

  Row buildRowFive({bool isPlainText = false, bool showBiometric = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBiometricKey
            ? BiometricKey(
                isPlainText: isPlainText,
                biometricClicked: _biometricHandler,
              )
            : SizedBox(
                height: 56.h,
                width: 64.w,
              ),
        TextKey(
          isPlainText: isPlainText,
          text: '0',
          onTextInput: _textInputHandler,
        ),
        BackspaceKey(
          isPlainText: isPlainText,
          onBackspace: _backspaceHandler,
        ),
      ],
    );
  }

  Expanded buildRowFour({bool isPlainText = false}) {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: ' ',
            flex: 4,
            onTextInput: _textInputHandler,
          ),
          BackspaceKey(
            isPlainText: isPlainText,
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }
}
