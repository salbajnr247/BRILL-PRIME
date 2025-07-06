import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import 'custom_text.dart';

class CustomField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? type;
  final bool enabled;
  final String? labelText;
  final String? labelWidgetText;
  final double labelWidgetWidth;
  final bool showLabelWidget;
  final bool isRequiredField;
  final Color? bgColor;
  final int length;
  final bool hasBorder;
  final Widget? suffix;
  final Widget? prefixIcon;
  final int maxLines;
  final Color fillColor;
  final Color textColor;
  final Color cursorColor;
  final double contentPadding;
  final bool isCapitalizeSentence;
  final double fontSize;
  final VoidCallback? onTap;
  final Color suffixTextColor;
  final Color borderColor;
  final Color focusBorderColor;
  final String suffixText;
  final bool autoFocus;
  final List<TextInputFormatter>? formatters;
  final void Function(String?)? onChange;
  final double borderRadius;
  final Color hintTxtColor;
  const CustomField(this.hint, this.controller,
      {super.key,
      this.type,
      this.enabled = true,
      this.labelText,
      this.bgColor,
      this.length = TextField.noMaxLength,
      this.hasBorder = true,
      this.suffix,
      this.cursorColor = black,
      this.onChange,
      this.maxLines = 1,
      this.textColor = black,
      this.fillColor = white,
      this.contentPadding = 16,
      this.isCapitalizeSentence = true,
      this.isRequiredField = false,
      this.labelWidgetText,
      this.showLabelWidget = false,
      this.labelWidgetWidth = 100,
      this.onTap,
      this.prefixIcon,
      this.fontSize = 13,
      this.suffixText = "",
      this.suffixTextColor = Colors.white,
      this.borderColor = borderGrey,
      this.focusBorderColor = mainColor,
      this.formatters,
      this.borderRadius = 30,
      this.autoFocus = false,
      this.hintTxtColor = hintTextColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      autofocus: autoFocus,
      enabled: enabled,
      textCapitalization: isCapitalizeSentence
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      maxLength: length,
      maxLines: maxLines,
      cursorColor: cursorColor,
      inputFormatters: formatters,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: contentPadding.w, vertical: contentPadding.h),
        hintText: hint,
        labelText: labelText,
        suffixStyle: TextStyle(
          color: suffixTextColor,
        ),
        label: showLabelWidget
            ? Container(
                constraints: BoxConstraints(maxWidth: labelWidgetWidth.w),
                child: Row(
                  children: [
                    CustomText(text: labelWidgetText ?? ""),
                    isRequiredField
                        ? const CustomText(
                            text: "*",
                            textColor: red,
                          )
                        : Container()
                  ],
                ),
              )
            : null,
        counterText: '',
        hintStyle: TextStyle(
          color: hintTextColor,
          fontWeight: regularFont,
          fontSize: fontSize,
        ),
        labelStyle: TextStyle(
          color: labelTextColor,
          fontWeight: regularFont,
          fontSize: fontSize,
        ),
        fillColor: fillColor,
        filled: true,
        isDense: true,
        suffixIcon: suffix,
        prefixIcon: prefixIcon,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: hasBorder
              ? const BorderSide(color: mainColor, width: 1)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: hasBorder
              ? BorderSide(color: borderColor, width: 1)
              : BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: bg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: hasBorder
              ? BorderSide(color: focusBorderColor, width: 1)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class CustomField2 extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType type;
  final bool enabled;
  final String? label;
  final Color bgColor;
  final int length;
  final bool showBorder;
  final bool isSearchField;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final void Function(String?)? onChange;
  const CustomField2(this.hint, this.controller,
      {super.key,
      required this.type,
      this.enabled = true,
      this.label,
      this.isSearchField = false,
      this.contentPaddingHorizontal = 10,
      this.contentPaddingVertical = 10,
      this.showBorder = true,
      this.onChange,
      this.bgColor = white,
      this.length = TextField.noMaxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      enabled: enabled,
      onChanged: onChange,
      textCapitalization: TextCapitalization.sentences,
      maxLength: length,
      style: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: contentPaddingHorizontal.w,
              vertical: contentPaddingVertical.h),
          hintText: hint,
          labelText: label,
          counterText: '',
          labelStyle: const TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: isSearchField ? const Icon(Iconsax.search_normal) : null,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          fillColor: bgColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                showBorder ? const BorderSide(color: bg) : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: showBorder
                ? const BorderSide(color: mainColor, width: 1)
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                showBorder ? const BorderSide(color: bg) : BorderSide.none,
          )),
    );
  }
}

class CustomOutlnField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? type;
  final bool enabled;
  final String? label;
  const CustomOutlnField(this.hint, this.controller,
      {super.key, this.type, this.enabled = true, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0x23000000),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromARGB(105, 0, 0, 0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mainColor, width: 1),
        ),
      ),
    );
  }
}

class CustomFieldPrefix extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? type;
  final bool enabled;
  final String? label;
  final String prefix;
  final Color bgColor;
  const CustomFieldPrefix(
    this.hint,
    this.controller, {
    super.key,
    this.type = const TextInputType.numberWithOptions(decimal: true),
    this.enabled = true,
    this.label,
    this.prefix = "",
    this.bgColor = white,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            prefix,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 15,
        ),
        fillColor: bgColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: bg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mainColor, width: 1),
        ),
      ),
    );
  }
}

class PwdField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isObscured;
  final VoidCallback onTap;
  final String hint;
  final Color bgColor;
  final String? label;
  final bool hasBorder;
  final Widget? prefixIcon;
  final int maxLength;
  final double borderRadius;
  final TextInputType? textInputType;
  final FontWeight fontWeight;
  final List<TextInputFormatter>? formatters;
  const PwdField(
      {super.key,
      this.controller,
      this.isObscured = true,
      required this.onTap,
      this.hint = "",
      this.bgColor = white,
      this.label = "",
      this.prefixIcon,
      this.formatters,
      this.maxLength = 100,
      this.borderRadius = 30,
      this.textInputType,
      this.fontWeight = semiBoldFont,
      this.hasBorder = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      cursorColor: black,
      inputFormatters: formatters,
      maxLength: maxLength,
      keyboardType: textInputType,
      style: TextStyle(
        color: black,
        fontWeight: fontWeight,
        fontSize: 14,
      ),
      decoration: InputDecoration(
          counterText: "",
          labelStyle: TextStyle(
            color: labelTextColor,
            fontWeight: fontWeight,
            fontSize: 11,
          ),
          hintText: hint,
          fillColor: bgColor,
          filled: true,
          isDense: true,
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontWeight: fontWeight,
            fontSize: 11,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(
              isObscured ? Iconsax.eye_slash : Iconsax.eye,
              color: black,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: hasBorder
                ? const BorderSide(
                    color: borderGrey,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: hasBorder
                ? const BorderSide(color: borderGrey, width: 1)
                : BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: bg),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: mainColor, width: 1),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)),
    );
  }
}

class MultiField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;
  final Color fillColor;
  const MultiField(this.hint, this.controller,
      {super.key, this.lines = 4, this.fillColor = white});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: lines,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintMaxLines: 3,
        filled: true,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: bg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: bg),
        ),
      ),
    );
  }
}

class CustomFieldBg extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType type;
  final bool enabled;
  const CustomFieldBg(this.label, this.controller,
      {super.key, this.type = TextInputType.text, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: enabled ? white : const Color(0xffdfdfdf),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: enabled ? black : const Color(0x4f0c0c0c),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextField(
            controller: controller,
            enabled: enabled,
            maxLines: null,
            keyboardType: type,
            style: const TextStyle(
              color: Color(0x9e2e2f2f),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

//Custom input decorations

InputDecoration drpDownDecoration = InputDecoration(
  filled: true,
  isDense: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
);

InputDecoration searchDecoration = InputDecoration(
  hintText: 'Search',
  isDense: true,
  filled: true,
  fillColor: white,
  prefixIcon: const Icon(Iconsax.search_normal),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  ),
);
