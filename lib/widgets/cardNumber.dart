// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CardNumber extends StatelessWidget {
  const CardNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.red)]),
      child: Center(child: Text("hola")),
    );
  }
}
