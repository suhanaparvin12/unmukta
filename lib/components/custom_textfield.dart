import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final Function(String?)? onsave;
  final int? maxLines;
  final bool isPassword;
  final bool enable;
  final bool? check;
  final TextInputType? keyboardtype;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;

  CustomTextField(
      {this.controller,
      this.check,
      this.enable = true,
      this.focusNode,
      this.hintText,
      this.isPassword = false,
      this.keyboardtype,
      this.maxLines,
      this.onsave,
      this.prefix,
      this.suffix,
      this.textInputAction,
      this.validate});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 15, letterSpacing: 1.5),
      textCapitalization: TextCapitalization.sentences,
      enabled: enable == true ? true : enable,
      maxLines: maxLines == null ? 1 : maxLines,
      onSaved: onsave,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardtype == null ? TextInputType.name : keyboardtype,
      controller: controller,
      validator: validate,
      obscureText: isPassword == false ? false : isPassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(22),
        filled: true,
        fillColor:
            Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
        prefixIcon: Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(child: prefix)),
        suffixIcon: suffix,
        labelText: hintText ?? "hint text..",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
              width: 2,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
              width: 2.5,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.errorContainer,
              width: 2,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.errorContainer,
              width: 2.5,
            )),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
