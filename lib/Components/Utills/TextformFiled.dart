import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Function()? togglePassword;
  final bool showSuffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextStyle? hintTextStyle;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool? filled;
  final Color? fillColor;
  final ValueChanged<String>? onChanged; // <-- Added this line

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.togglePassword,
    this.showSuffixIcon = false,
    this.validator,
    this.suffixIcon,
    this.inputFormatters,
    this.keyboardType,
    this.hintTextStyle,
    this.readOnly = false,
    this.onTap,
    this.filled,
    this.fillColor,
    this.onChanged, // <-- Added this line to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged, // <-- Passed onChanged to TextFormField
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        hintText: hintText,
        hintStyle: hintTextStyle ?? GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.0,
          letterSpacing: 0,
          textStyle: const TextStyle(
            color: Color(0xFFA4A4A4),
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        filled: filled ?? true,
        fillColor: fillColor ?? Colors.white,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          height: 0.8,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFD4D4D4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFD4D4D4), width: 1),
        ),
        suffixIcon: suffixIcon ?? (showSuffixIcon
            ? IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: togglePassword,
        )
            : null),
      ),
    );
  }
}



