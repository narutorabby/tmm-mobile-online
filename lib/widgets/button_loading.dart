import 'package:flutter/material.dart';

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 10),
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
      ),
    );
  }
}
