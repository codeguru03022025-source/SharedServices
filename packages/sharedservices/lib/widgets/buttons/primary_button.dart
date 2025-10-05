import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharedservices/utils/app_utils.dart';

class PrimaryText extends StatefulWidget {
  final String text;
  final Color color;
  final FontWeight? fontWeight;
  final double? lineSpacing;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final int? minLines;
  final EdgeInsets padding;
  final void Function(bool)? isLoading;

  const PrimaryText(
      this.text, {
        Key? key,
        this.color = Colors.black,
        this.fontWeight,
        this.lineSpacing,
        this.fontSize,
        this.textAlign,
        this.textOverflow,
        this.maxLines,
        this.minLines,
        this.padding = const EdgeInsets.all(0),
        this.isLoading,
      }): super(key: key);

  @override
  State<PrimaryText> createState() => _PrimaryTextState();
}


class _PrimaryTextState extends State<PrimaryText> {

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Padding(
        padding: widget.padding,
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          textScaler: TextScaler.linear(
            AppUtils.isTab ? 1.2 : (context.width > 400 ? 1.0 : 0.8),
          ),
          overflow: widget.textOverflow,
          maxLines: widget.maxLines,
          style: TextStyle(
            height: widget.lineSpacing,
            color: widget.color,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }
}


