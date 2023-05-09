import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final double? wordSpacing;
  final VoidCallback? onClick;

  const UserText(
      {
      required this.text, this.size,
       this.fontWeight,
       this.color,
       this.wordSpacing,
       this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: onClick == null
          ? Text(
        text,
        style: GoogleFonts.lato(
          fontSize: size ?? 32,
          fontWeight: fontWeight ?? FontWeight.w800,
          color: color ?? Colors.black,
          wordSpacing: wordSpacing,
        ),
      )
          : TextButton(
        onPressed: () {
          onClick?.call();
        },
        child: Text(
          text,
          style: GoogleFonts.lato(
            fontSize: size ?? 32,
            fontWeight: fontWeight ?? FontWeight.w700,
            color: color ?? Colors.black,
            wordSpacing: wordSpacing,
          ),
        ),
      ),
    );
  }
}
