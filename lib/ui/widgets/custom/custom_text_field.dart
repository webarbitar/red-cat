import 'package:flutter/material.dart';

import '../../../core/constance/style.dart';

class CustomTextField extends StatefulWidget {
  final FormFieldValidator? validator;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final double? height;
  final String? hint;
  final bool enable;
  final bool obscure;
  final int? minLine;
  final String? labelText;
  final TextStyle? textStyle;
  final Function(String)? onChangeText;
  final TextInputType type;
  final TextInputAction inputAction;
  final Color? color;
  final Widget? prefixIcon;
  final bool needDecoration;

  const CustomTextField({
    Key? key,
    this.hintStyle,
    this.hint,
    this.textStyle,
    this.onChangeText,
    required this.controller,
    this.type = TextInputType.text,
    this.color,
    this.prefixIcon,
    this.needDecoration = true,
    this.validator,
    this.inputAction = TextInputAction.done,
    this.focusNode,
    this.obscure = false,
    this.enable = true,
    this.minLine,
    this.height = 45,
    this.labelText,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  Widget _buildObscureAction() {
    var icon = Icons.visibility_off;
    if (!_obscure) icon = Icons.visibility;
    return IconButton(
      iconSize: 20,
      icon: Icon(
        icon,
        color: widget.color,
      ),
      onPressed: () {
        setState(() {
          _obscure = !_obscure;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: widget.minLine != null ? 12 : 2),
      decoration: widget.needDecoration
          ? BoxDecoration(
              color: widget.color ?? Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withAlpha(50)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  spreadRadius: -5,
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
            )
          : BoxDecoration(
              color: widget.color ?? Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.shade200),
            ),
      child: SizedBox(
        height: widget.minLine != null ? null : widget.height,
        child: Center(
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            cursorColor: Colors.black,
            style: widget.textStyle,
            cursorWidth: 1,
            obscureText: _obscure,
            textAlign: TextAlign.left,
            enabled: widget.enable,
            minLines: widget.minLine,
            maxLines: null,
            onChanged: widget.onChangeText,
            decoration: InputDecoration(
              suffixIcon: widget.obscure ? _buildObscureAction() : null,
              prefixIcon: widget.prefixIcon,
              // border: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              disabledBorder: InputBorder.none,
              hintText: widget.hint,
              labelText: widget.labelText,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              errorStyle: const TextStyle(height: 0),
              hintStyle: widget.hintStyle ??
                  TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      letterSpacing: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
