import 'package:flutter/material.dart';

class Fullinfo extends StatelessWidget {
  late final String? q;
  late final String? a;
  late final qImage;
  late final aImage;

  Fullinfo(String q, String a, {qImage, aImage}) {
    this.q = q;
    this.a = a;
    this.qImage = qImage;
    this.aImage = aImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            q!,
          ),
          Image(image: NetworkImage('')),
          Divider(
            thickness: 3,
          ),
          Image(image: NetworkImage('')),
          Text(
            a!,
          )
        ],
      ),
    );
  }
}
