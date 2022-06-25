import 'package:flutter/material.dart';

class AllCategori extends StatelessWidget  {
int currentPage;
 AllCategori({Key? key, required this.currentPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(
        right: 32,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(
              height: currentPage == 1 ? 50 : 24 ,
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

