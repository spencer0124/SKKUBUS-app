import 'package:flutter/material.dart';

class TransferLine {
  final String line;
  final Color color;

  const TransferLine({required this.line, required this.color});

  factory TransferLine.fromJson(Map<String, dynamic> json) {
    return TransferLine(
      line: json['line'] as String,
      color: Color(int.parse('0xFF${json['color']}')),
    );
  }
}
