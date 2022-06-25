import 'dart:math';

import 'package:flutter/material.dart';


class pagePast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Size.infinite.width,
        height: Size.infinite.height,
        color: Colors.red,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 325,),
                Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(300),
                    boxShadow: const [BoxShadow(
                      blurRadius: 25,
                      color: Colors.white12,
                      offset: Offset(0, 5),
                    )],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
